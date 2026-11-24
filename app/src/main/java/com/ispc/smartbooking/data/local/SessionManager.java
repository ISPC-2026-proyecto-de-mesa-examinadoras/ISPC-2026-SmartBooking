package com.ispc.smartbooking.data.local;

import android.content.Context;
import android.content.SharedPreferences;

public class SessionManager {

    private static final String PREFS = "smartbooking_session";
    private static final String KEY_ACCESS = "access_token";

    private final SharedPreferences prefs;

    public SessionManager(Context context) {
        prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
    }

    public void saveAccessToken(String token) {
        prefs.edit().putString(KEY_ACCESS, token).apply();
    }

    public String getAccessToken() {
        return prefs.getString(KEY_ACCESS, null);
    }

    public void clear() {
        prefs.edit().clear().apply();
    }
}