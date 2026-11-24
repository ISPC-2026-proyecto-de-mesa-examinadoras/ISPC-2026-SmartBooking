package com.ispc.smartbooking;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import com.ispc.smartbooking.data.api.RetrofitClient;
import com.ispc.smartbooking.data.local.SessionManager;
import com.ispc.smartbooking.data.model.AuthResponse;
import com.ispc.smartbooking.data.model.LoginRequest;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class LoginActivity extends AppCompatActivity {

    private static final String HARDCODED_EMAIL = "kevin@gmail.com";
    private static final String HARDCODED_PASSWORD = "kevin@gmail.com";

    public static final String EXTRA_EMAIL = "email";

    private TextInputEditText etEmail;
    private TextInputEditText etPassword;
    private ProgressBar progressLogin;
    private MaterialButton btnIngresar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        etEmail = findViewById(R.id.etEmail);
        etPassword = findViewById(R.id.etPassword);
        progressLogin = findViewById(R.id.progressLogin);
        btnIngresar = findViewById(R.id.btnIngresar);
        TextView tvRegistro = findViewById(R.id.tvRegistro);

        String emailDesdeRegistro = getIntent().getStringExtra(EXTRA_EMAIL);
        if (emailDesdeRegistro != null) {
            etEmail.setText(emailDesdeRegistro);
        } else {
            etEmail.setText(HARDCODED_EMAIL);
            etPassword.setText(HARDCODED_PASSWORD);
        }

        btnIngresar.setOnClickListener(v -> iniciarSesion());
        tvRegistro.setOnClickListener(v ->
                startActivity(new Intent(this, RegisterActivity.class)));
    }

    private void iniciarSesion() {
        clearErrors();

        String email = textoDe(etEmail);
        String password = etPassword.getText() == null ? "" : etPassword.getText().toString();

        if (email.isEmpty()) {
            setError(etEmail, getString(R.string.error_email_required));
            return;
        }
        if (!android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
            setError(etEmail, getString(R.string.error_email_invalid));
            return;
        }
        if (password.isEmpty()) {
            setError(etPassword, getString(R.string.error_password_required));
            return;
        }

        if (HARDCODED_EMAIL.equals(email) && HARDCODED_PASSWORD.equals(password)) {
            new SessionManager(this).saveAccessToken("dev-local-token");
            startActivity(new Intent(this, HomeActivity.class));
            finish();
            return;
        }

        setLoading(true);
        LoginRequest body = new LoginRequest(email, password);
        RetrofitClient.getApi().login(body).enqueue(new Callback<AuthResponse>() {
            @Override
            public void onResponse(Call<AuthResponse> call, Response<AuthResponse> response) {
                setLoading(false);
                if (response.isSuccessful() && response.body() != null) {
                    String access = response.body().access;
                    if (access == null || access.isEmpty()) {
                        Toast.makeText(LoginActivity.this, R.string.error_login_generic, Toast.LENGTH_LONG).show();
                        return;
                    }
                    new SessionManager(LoginActivity.this).saveAccessToken(access);
                    startActivity(new Intent(LoginActivity.this, HomeActivity.class));
                    finish();
                    return;
                }
                if (response.code() == 401) {
                    Toast.makeText(LoginActivity.this, R.string.error_login_unauthorized, Toast.LENGTH_LONG).show();
                    return;
                }
                Toast.makeText(LoginActivity.this, R.string.error_login_generic, Toast.LENGTH_LONG).show();
            }

            @Override
            public void onFailure(Call<AuthResponse> call, Throwable t) {
                setLoading(false);
                Toast.makeText(LoginActivity.this, R.string.error_network, Toast.LENGTH_LONG).show();
            }
        });
    }

    private void setLoading(boolean loading) {
        progressLogin.setVisibility(loading ? View.VISIBLE : View.GONE);
        btnIngresar.setEnabled(!loading);
    }

    private void clearErrors() {
        setError(etEmail, null);
        setError(etPassword, null);
    }

    private void setError(TextInputEditText field, String message) {
        View parent = (View) field.getParent().getParent();
        if (parent instanceof TextInputLayout) {
            ((TextInputLayout) parent).setError(message);
        }
    }

    private String textoDe(TextInputEditText campo) {
        return campo.getText() == null ? "" : campo.getText().toString().trim();
    }
}