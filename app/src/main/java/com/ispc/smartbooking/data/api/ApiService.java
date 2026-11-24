package com.ispc.smartbooking.data.api;

import com.ispc.smartbooking.data.model.AuthResponse;
import com.ispc.smartbooking.data.model.LoginRequest;
import com.ispc.smartbooking.data.model.RegisterRequest;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.POST;

public interface ApiService {

    @POST("api/auth/register/")
    Call<Void> register(@Body RegisterRequest request);

    @POST("api/auth/login/")
    Call<AuthResponse> login(@Body LoginRequest request);
}