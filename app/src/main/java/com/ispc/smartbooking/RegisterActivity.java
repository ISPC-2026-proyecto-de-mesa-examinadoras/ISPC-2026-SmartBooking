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
import com.ispc.smartbooking.data.model.RegisterRequest;
import com.ispc.smartbooking.utils.PasswordValidator;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class RegisterActivity extends AppCompatActivity {

    private TextInputEditText etNombreCompleto;
    private TextInputEditText etEmail;
    private TextInputEditText etPassword;
    private TextInputEditText etPasswordConfirm;
    private ProgressBar progressRegister;
    private MaterialButton btnRegistrar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);

        etNombreCompleto = findViewById(R.id.etNombreCompleto);
        etEmail = findViewById(R.id.etEmail);
        etPassword = findViewById(R.id.etPassword);
        etPasswordConfirm = findViewById(R.id.etPasswordConfirm);
        progressRegister = findViewById(R.id.progressRegister);
        btnRegistrar = findViewById(R.id.btnRegistrar);
        TextView tvLogin = findViewById(R.id.tvLogin);

        btnRegistrar.setOnClickListener(v -> registrar());
        tvLogin.setOnClickListener(v -> finish());
    }

    private void registrar() {
        clearErrors();

        String nombre = textoDe(etNombreCompleto);
        String email = textoDe(etEmail);
        String password = textoDe(etPassword);
        String confirm = textoDe(etPasswordConfirm);

        if (nombre.isEmpty()) {
            setError(etNombreCompleto, getString(R.string.error_name_required));
            return;
        }
        if (email.isEmpty()) {
            setError(etEmail, getString(R.string.error_email_required));
            return;
        }
        if (!android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
            setError(etEmail, getString(R.string.error_email_invalid));
            return;
        }
        if (!PasswordValidator.isStrong(password)) {
            setError(etPassword, getString(R.string.error_password_policy));
            return;
        }
        if (!password.equals(confirm)) {
            setError(etPasswordConfirm, getString(R.string.error_password_mismatch));
            return;
        }

        setLoading(true);
        RegisterRequest body = new RegisterRequest(nombre, email, password, confirm);
        RetrofitClient.getApi().register(body).enqueue(new Callback<Void>() {
            @Override
            public void onResponse(Call<Void> call, Response<Void> response) {
                setLoading(false);
                if (response.isSuccessful()) {
                    Toast.makeText(RegisterActivity.this, R.string.register_success, Toast.LENGTH_SHORT).show();
                    Intent intent = new Intent(RegisterActivity.this, LoginActivity.class);
                    intent.putExtra(LoginActivity.EXTRA_EMAIL, email);
                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                    startActivity(intent);
                    finish();
                    return;
                }
                if (response.code() == 400 && response.errorBody() != null) {
                    try {
                        String error = response.errorBody().string();
                        if (error.contains("email")) {
                            setError(etEmail, getString(R.string.error_register_email));
                        } else if (error.contains("password")) {
                            setError(etPassword, getString(R.string.error_password_policy));
                        } else {
                            Toast.makeText(RegisterActivity.this, R.string.error_register_generic, Toast.LENGTH_LONG).show();
                        }
                    } catch (Exception e) {
                        Toast.makeText(RegisterActivity.this, R.string.error_register_generic, Toast.LENGTH_LONG).show();
                    }
                    return;
                }
                Toast.makeText(RegisterActivity.this, R.string.error_register_generic, Toast.LENGTH_LONG).show();
            }

            @Override
            public void onFailure(Call<Void> call, Throwable t) {
                setLoading(false);
                Toast.makeText(RegisterActivity.this, R.string.error_network, Toast.LENGTH_LONG).show();
            }
        });
    }

    private void setLoading(boolean loading) {
        progressRegister.setVisibility(loading ? View.VISIBLE : View.GONE);
        btnRegistrar.setEnabled(!loading);
    }

    private void clearErrors() {
        setError(etNombreCompleto, null);
        setError(etEmail, null);
        setError(etPassword, null);
        setError(etPasswordConfirm, null);
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