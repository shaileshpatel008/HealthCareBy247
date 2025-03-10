package com.healthcarelab
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import androidx.appcompat.app.AppCompatActivity

class SplashActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.splash_screen)

        // Delay splash screen for 2 seconds
        Handler().postDelayed({
            // Navigate to MainActivity
            val intent = Intent(this@SplashActivity, MainActivity::class.java)
            startActivity(intent)
            finish()  // Close the SplashActivity
        }, 2000)  // 2000ms = 2 seconds
    }
}