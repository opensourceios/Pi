package layout;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.util.Log;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

import br.com.dina.ui.widget.UITableView;
import br.com.dina.ui.widget.UITableView.ClickListener;

import tech.rigo.pi.R;
import tech.rigo.pi.SignUpActivity;
import tech.rigo.pi.Subject;
import tech.rigo.pi.SubjectsAdapter;

import java.util.ArrayList;

public class SubjectsFragment extends Fragment {
    public SubjectsFragment() {
        // Required empty public constructor
    }
    
    private ListView mListView;
    
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_subjects, container, false);

        mListView = (ListView) rootView.findViewById(R.id.subjects_list_view);

        Subject subject;
        ArrayList<Subject> subjects = new ArrayList<Subject>();
        
        // NOTE: Just a test subjects.
        subject = new Subject();
        subject.setName("Algebra 1");
        subject.setFormulaCount(10);
        subjects.add(subject);
        
        subject = new Subject();
        subject.setName("Geometry");
        subject.setFormulaCount(9);
        subjects.add(subject);
        
        mListView.setAdapter(new SubjectsAdapter(getActivity(), subjects));
        
        // ListView Item Click Listener
        mListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {

                // ListView Clicked item index
                int itemPosition = position;

                // ListView Clicked item value
                Subject itemValue = (Subject) mListView.getItemAtPosition(position);
                String subjectValue = itemValue.getName() + " - " + itemValue.getFormulaCount();
                
                // Show Alert 
                Toast.makeText(getActivity(),
                        "Position :" + itemPosition + "  ListItem : " + subjectValue, Toast.LENGTH_SHORT)
                        .show();

            }
        });
        
        return rootView;
    }
}
