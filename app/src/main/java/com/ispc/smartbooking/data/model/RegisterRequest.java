package com.ispc.smartbooking.data.model;

import com.google.gson.annotations.SerializedName;

public class RegisterRequest {

    public String email;
    public String password;

    @SerializedName("password2")
    public String password2;

    public String nombre;

    public RegisterRequest(String nombre, String email, String password, String password2) {
        this.nombre = nombre;
        this.email = email;
        this.password = password;
        this.password2 = password2;
    }
}