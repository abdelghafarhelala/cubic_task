# Troubleshooting CocoaPods (pod install) Issues

If `pod install` is stuck or hanging, try these solutions:

## Quick Fixes

### 1. Clean CocoaPods Cache
```bash
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf ~/Library/Caches/CocoaPods
pod cache clean --all
```

### 2. Update CocoaPods Repo
```bash
pod repo update
```

### 3. Reinstall Pods
```bash
cd ios
pod deintegrate
pod install --repo-update
```

### 4. Use Flutter's Pod Install (Recommended)
Instead of running `pod install` manually, use Flutter's command:
```bash
cd ios
flutter clean
flutter pub get
cd ios
pod install
```

## Common Issues & Solutions

### Issue: Pod install hangs on "Analyzing dependencies"

**Solution 1: Update CocoaPods**
```bash
sudo gem install cocoapods
pod repo update
```

**Solution 2: Use verbose mode to see where it's stuck**
```bash
cd ios
pod install --verbose
```

**Solution 3: Skip repo update (if repo update is the issue)**
```bash
cd ios
pod install --no-repo-update
```

### Issue: Network timeout downloading pods

**Solution: Use CDN instead of git**
```bash
cd ios
pod install --repo-update
# Or manually update Podfile to use CDN (already configured in Flutter projects)
```

### Issue: Firebase dependencies taking too long

**Solution: Install Firebase pods separately**
```bash
cd ios
pod install --verbose
# Wait for Firebase pods to download (can take 5-10 minutes)
```

### Issue: Permission errors

**Solution: Fix CocoaPods permissions**
```bash
sudo gem install cocoapods
pod setup
```

## Complete Reset (Nuclear Option)

If nothing works, completely reset CocoaPods:

```bash
cd ios

# Remove all CocoaPods files
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec

# Clean CocoaPods cache
pod cache clean --all
rm -rf ~/Library/Caches/CocoaPods

# Update repo
pod repo update

# Reinstall
flutter clean
flutter pub get
cd ios
pod install
```

## Alternative: Use Flutter's Built-in Pod Install

Flutter can handle pod installation automatically:

```bash
# From project root
flutter clean
flutter pub get
flutter build ios --no-codesign
# This will automatically run pod install
```

## Check What's Happening

### Monitor pod install progress:
```bash
cd ios
pod install --verbose 2>&1 | tee pod_install.log
```

### Check if it's actually working:
Open another terminal and check:
```bash
ps aux | grep pod
# or
lsof -i | grep pod
```

## Firebase-Specific Issues

If Firebase pods are causing issues:

1. **Check internet connection** - Firebase pods are large
2. **Use stable versions** - Check `pubspec.yaml` for Firebase versions
3. **Clear Firebase cache**:
   ```bash
   rm -rf ~/Library/Caches/CocoaPods/Pods/External
   ```

## Prevention Tips

1. **Always run from project root first**:
   ```bash
   flutter pub get
   cd ios
   pod install
   ```

2. **Keep CocoaPods updated**:
   ```bash
   sudo gem install cocoapods
   ```

3. **Use Flutter's commands when possible**:
   ```bash
   flutter build ios --no-codesign
   ```

## Still Stuck?

If `pod install` is still hanging after 15+ minutes:

1. **Kill the process**:
   ```bash
   pkill -f pod
   ```

2. **Check system resources**:
   ```bash
   top
   # Check if CPU/memory is maxed out
   ```

3. **Try installing specific pods**:
   ```bash
   cd ios
   pod install --verbose | grep -i firebase
   # This will show Firebase-specific issues
   ```

4. **Check Xcode version compatibility**:
   - Ensure Xcode is up to date
   - Check if your CocoaPods version is compatible

## Quick Diagnostic

Run this to see what's happening:
```bash
cd ios
echo "=== CocoaPods Version ==="
pod --version
echo "=== Flutter Version ==="
flutter --version
echo "=== Xcode Version ==="
xcodebuild -version
echo "=== Checking Podfile ==="
cat Podfile
```



