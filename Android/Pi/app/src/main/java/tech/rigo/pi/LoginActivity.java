package tech.rigo.pi;

import android.content.DialogInterface;
import android.content.Intent;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class LoginActivity extends AppCompatActivity {
    
    Button loginButton;
    EditText usernameTextField;
    EditText passwordTextField;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        this.loginButton = (Button) findViewById(R.id.loginButton);
        this.usernameTextField = (EditText) findViewById(R.id.usernameTextField);
        this.passwordTextField = (EditText) findViewById(R.id.passwordTextField);
    }
    
    public void login(View v) {
        Intent MainActivityIntent = new Intent(this, TestActivity.class);
        startActivity(MainActivityIntent);
    }
    
    public void signUpInstead(View v) {
        Intent SUIIntent = new Intent(this, SignUpActivity.class);
        startActivity(SUIIntent);
    }
}
