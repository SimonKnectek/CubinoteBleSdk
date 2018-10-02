package com.cubinote.CubinoteBLEDemo;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Base64;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import com.cubinote.CubinoteBLE.R;
import com.cubinote.cubinoteblesdk.CubinoteBLE;
import com.cubinote.cubinoteblesdk.InnerContent;
import com.cubinote.cubinoteblesdk.TextItem;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Set;

public class BleDemoActivity extends AppCompatActivity {
    Spinner spinner,spinner2,spinner3,spinner4,spinner5;
    BluetoothAdapter mBluetoothAdapter;
    Set<BluetoothDevice> pairedDevices;
    ArrayList<BluetoothDevice> items = new ArrayList<>();
    ArrayList<String> itemnames = new ArrayList<>();
    EditText resultText;

    CubinoteBLE SDK = new CubinoteBLE();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ble_demo);

        spinner = (Spinner) findViewById(R.id.spinner);
        spinner.setOnItemSelectedListener(new MyOnItemSelectedListener());

        spinner2 = (Spinner) findViewById(R.id.spinner2);
        spinner2.setOnItemSelectedListener(new MyOnItemSelectedListener());
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this, R.array.value0to1, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner2.setAdapter(adapter);
        spinner2.setSelection(1);

        spinner3 = (Spinner) findViewById(R.id.spinner3);
        spinner3.setOnItemSelectedListener(new MyOnItemSelectedListener());
        spinner3.setAdapter(adapter);
        spinner3.setSelection(1);

        spinner4 = (Spinner) findViewById(R.id.spinner4);
        spinner4.setOnItemSelectedListener(new MyOnItemSelectedListener());
        ArrayAdapter<CharSequence> adapter1 = ArrayAdapter.createFromResource(this, R.array.value0to21, android.R.layout.simple_spinner_item);
        adapter1.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner4.setAdapter(adapter1);
        spinner4.setSelection(1);

        spinner5 = (Spinner) findViewById(R.id.spinner5);
        spinner5.setOnItemSelectedListener(new MyOnItemSelectedListener());
        spinner5.setAdapter(adapter);
        spinner5.setSelection(1);

        resultText = (EditText) findViewById(R.id.editText1);

        Button btnGetStatus = (Button) findViewById(R.id.button1);
        btnGetStatus.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                resultText.setText(SDK.CubinoteBLE_GetStatus(items.get(spinner.getSelectedItemPosition())));
            }
        });

        Button btnSetPrinter = (Button) findViewById(R.id.button2);
        btnSetPrinter.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int led = Integer.parseInt(spinner2.getSelectedItem().toString());
                int buz = Integer.parseInt(spinner3.getSelectedItem().toString());
                int speed = Integer.parseInt(spinner4.getSelectedItem().toString());
                int languageId = Integer.parseInt(spinner5.getSelectedItem().toString());
                resultText.setText(SDK.CubinoteBLE_Set(items.get(spinner.getSelectedItemPosition()), led, buz, speed, languageId));
            }
        });

        Button btnSendBWImage = (Button) findViewById(R.id.button3);
        btnSendBWImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                InputStream inStream = getResources().openRawResource(R.raw.after);
                try {
                    byte[] pimage = new byte[inStream.available()];
                    inStream.read(pimage);
                    resultText.setText(SDK.CubinoteBLE_Print_BWImage(items.get(spinner.getSelectedItemPosition()), pimage));
                }
                catch (IOException e){
                    ;
                }
            }
        });

        Button btnSendContent = (Button) findViewById(R.id.button4);
        btnSendContent.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Create a solid line
                TextItem t1 = new TextItem(41);
                //Create print content with the solid line
                InnerContent inerContent = new InnerContent(t1);

                //Create a regular text and insert it into print content
                String text = "Test Cubinote SDK";
                TextItem t2 = new TextItem(text, 1);
                inerContent.textList.add(t2);

                //Create a big font, bold and underline text and insert it into print content
                TextItem t3 = new TextItem(text, 1);
                t3.underline = 130;
                t3.bold = 1;
                t3.fontSize = 2;
                inerContent.textList.add(t3);

                //Create a QR code and insert it into print content
                String qr = "Test QR Code";
                TextItem t4 = new TextItem(qr, 3);
                inerContent.textList.add(t4);

                //Create a material and insert it into print content
                TextItem t5 = new TextItem(10);
                inerContent.textList.add(t5);

                //Create a Monochrome bitmap and insert it into print content
                InputStream inStream = getResources().openRawResource(R.raw.after);
                try {
                    byte[] pimage = new byte[inStream.available()];
                    inStream.read(pimage);
                    String base64String = Base64.encodeToString(pimage,0, pimage.length, Base64.NO_WRAP);
                    TextItem p1 = new TextItem(base64String, 5);
                    inerContent.textList.add(p1);
                    /*TextItem p2 = new TextItem(base64String, 5);
                    inerContent.textList.add(p2);
                    TextItem p3 = new TextItem(base64String, 5);
                    inerContent.textList.add(p3);
                    TextItem p4 = new TextItem(base64String, 5);
                    inerContent.textList.add(p4);
                    TextItem p5 = new TextItem(base64String, 5);
                    inerContent.textList.add(p5);
                    TextItem p6 = new TextItem(base64String, 5);
                    inerContent.textList.add(p6);
                    TextItem p7 = new TextItem(base64String, 5);
                    inerContent.textList.add(p7);
                    TextItem p8 = new TextItem(base64String, 5);
                    inerContent.textList.add(p8);
                    TextItem p9 = new TextItem(base64String, 5);
                    inerContent.textList.add(p9);
                    TextItem p10 = new TextItem(base64String, 5);
                    inerContent.textList.add(p10);*/
                }
                catch (IOException e){
                    ;
                }

                //Create a dash line and insert it into print content
                TextItem t6 = new TextItem(42);
                inerContent.textList.add(t6);

                //Create a Cubinote Logo and insert it into print content
                TextItem t7 = new TextItem(57);
                inerContent.textList.add(t7);

                resultText.setText(SDK.CubinoteBLE_Print_Content(items.get(spinner.getSelectedItemPosition()), inerContent));
            }
        });

        initBlutooth();
    }

    private void initBlutooth(){
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if (mBluetoothAdapter == null) {
            // Device doesn't support Bluetooth
            Toast.makeText(this, "Device doesn't support Bluetooth.",Toast.LENGTH_LONG).show();
            return;
        }

        if (!mBluetoothAdapter.isEnabled()) {
            Toast.makeText(this, "Please turn on Bluetooth.",Toast.LENGTH_LONG).show();;
            return;
        }

        pairedDevices = mBluetoothAdapter.getBondedDevices();

        if (pairedDevices.size() > 0) {
            // There are paired devices. Get the name and address of each paired device.
            for (BluetoothDevice device : pairedDevices) {
                String deviceName = device.getName();
                if(deviceName.startsWith("Cubinote")){
                    //String deviceHardwareAddress = device.getAddress(); // MAC address
                    items.add(device);
                    itemnames.add(deviceName);
                }
            }
        }

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_dropdown_item, itemnames);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);
    }

    public  class MyOnItemSelectedListener implements AdapterView.OnItemSelectedListener {

        public void onItemSelected(AdapterView<?> parent,
                                   View view, int pos, long id) {
            //;
        }

        public void onNothingSelected(AdapterView parent) {
            // Do nothing.
        }
    }
}
