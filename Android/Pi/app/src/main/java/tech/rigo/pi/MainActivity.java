package tech.rigo.pi;

import android.content.DialogInterface;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {
    
    Button loginButton;
    EditText usernameTextField;
    EditText passwordTextField;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        this.loginButton = (Button) findViewById(R.id.loginButton);
        this.usernameTextField = (EditText) findViewById(R.id.usernameTextField);
        this.passwordTextField = (EditText) findViewById(R.id.passwordTextField);
    }
    
    public void login(View v) {
        new AlertDialog.Builder(this)
                .setTitle("Success")
                .setMessage("You are logged in!")
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        
                    }
                })
                .show();
    }
    
    public void signUpInstead(View v) {
        Toast sampleToast = Toast.makeText(getApplicationContext(), "You chose Sign Up Instead", Toast.LENGTH_SHORT);
        sampleToast.show();
    }
}
