# Firebase SHA Key Setup Guide

## Your Device SHA Keys

### SHA-1 Fingerprint:
```
0A:55:E6:BA:EA:0C:7C:CE:D8:52:0A:98:92:AF:2F:50:62:3C:0F:7A
```

### SHA-256 Fingerprint:
```
98:7E:8C:C0:9A:B8:71:92:DE:B4:23:42:1C:E3:F3:DC:E0:59:9E:C2:1A:7D:0A:E4:65:B0:11:A7:9F:77:03:66
```

## Where to Add These Keys in Firebase

### Step-by-Step Instructions:

1. **Go to Firebase Console**
   - Visit: https://console.firebase.google.com/
   - Select your project: `neardeal-3d5f0`

2. **Navigate to Project Settings**
   - Click on the gear icon (⚙️) next to "Project Overview" at the top left
   - Select "Project settings"

3. **Find Your Android App**
   - Scroll down to the "Your apps" section
   - Find your Android app (package name: `com.neardeal.org`)
   - Click on it or look for the Android app section

4. **Add SHA Certificates**
   - In the Android app settings, you'll see a section called "SHA certificate fingerprints"
   - Click "Add fingerprint" button
   - Paste your **SHA-1** key: `0A:55:E6:BA:EA:0C:7C:CE:D8:52:0A:98:92:AF:2F:50:62:3C:0F:7A`
   - Click "Add fingerprint" again
   - Paste your **SHA-256** key: `98:7E:8C:C0:9A:B8:71:92:DE:B4:23:42:1C:E3:F3:DC:E0:59:9E:C2:1A:7D:0A:E4:65:B0:11:A7:9F:77:03:66`

5. **Download Updated google-services.json (Optional)**
   - After adding the SHA keys, you may want to download the updated `google-services.json`
   - Click "Download google-services.json" if available
   - Replace the existing file in your project root and `android/app/` directory

## Visual Guide

The path in Firebase Console is:
```
Firebase Console
  → Your Project (neardeal-3d5f0)
  → Project Settings (⚙️ icon)
  → Your apps section
  → Android app (com.neardeal.org)
  → SHA certificate fingerprints
  → Add fingerprint
```

## Important Notes

- These are **debug** keystore fingerprints
- For production builds, you'll need to add your **release** keystore SHA keys later
- After adding SHA keys, Google Sign-In should work properly
- You may need to wait a few minutes for changes to propagate

## Getting Release SHA Keys (For Later)

When you're ready to build a release version, get the release keystore SHA keys:

```bash
keytool -list -v -keystore /path/to/your/release.keystore -alias your-key-alias
```

Replace `/path/to/your/release.keystore` and `your-key-alias` with your actual release keystore details.
