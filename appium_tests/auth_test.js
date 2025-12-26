const { remote } = require('webdriverio');

const opts = {
  path: '/',
  port: 4723,
  capabilities: {
    platformName: "Android",
    "appium:automationName": "UiAutomator2",
    "appium:deviceName": "Android Emulator", // اسم المحاكي بتاعك
    "appium:app": "D:/path/to/your/app.apk", // مسار ملف الـ APK بتاعك
  }
};

async function main () {
  const client = await remote(opts);
  
  // هنا بنقول لـ Appium يدور على زرار الـ Signup ويضغط عليه
  const signupBtn = await client.$('~signup_button'); // الاسم اللي اخترناه في الـ Tooltip
  await signupBtn.click();

  await client.deleteSession();
}

main();