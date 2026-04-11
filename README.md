# FitQuest

**Your fitness, your phone.** A youth-focused fitness & nutrition app for **Android**, with a consistent blue brand, accurate tracking, and no external devices.

## Platform

- **Android-first.** Step tracking uses the device motion / step counter sensor (no wearables). Grant **Activity recognition** when prompted for accurate steps.
- Other platforms (iOS, desktop) can run the app; step count will be 0 unless you add platform-specific sensors later.

## Use & Features

### 1. 🌓 Dark Theme Support
- Complete dark mode with theme toggle (header)
- Persistent theme selection
- Smooth transitions between themes

### 2. 📱 Responsive & Mobile-First UI
- Optimized for mobile (320px+)
- Touch-friendly buttons and bottom navigation
- Sticky header for persistent navigation
- Modals/dialogs adapt to screen size

### 3. 👤 User Profile Management
- Access via user icon in top-right header
- Edit profile: name, age, gender, height, weight (with BMI), email, phone
- Activity level, diet plan preferences, fitness goals
- Data stored locally; user has full control

### 4. ✅ Confirmation Dialogs
- Food entries: confirm before adding
- Exercise entries: confirm before adding
- Delete operations: confirm before removing
- Prevents accidental entries

### 5. 📊 Prefilled / Historical Data
- Historical data for exploration
- Realistic Indian meals across meal types
- Variety of exercises (Yoga, Cricket, Badminton, etc.)
- Daily totals and weekly trends
- Data persists locally

### 6. 🚶 Step Tracking (device sensor, no external devices)
- Uses your **phone’s motion / step counter** (Android). No bands or wearables.
- Accurate step count; resets at midnight; persists across app restarts
- Progress towards 10,000 step goal; distance from steps; 10K achievement

### 7. 🤖 Interactive AI Recommendations
- Time-based: morning (breakfast, pranayama), afternoon (largest meal, post-lunch walk), evening (snacks, yoga), night (light dinner, sleep)
- Context-aware: calories consumed, exercise type, diet plan, goals
- Indian-specific: Ayurvedic principles, traditional health, cultural meal timing, yoga/meditation

### 8. 🇮🇳 India-Specific Features
- Traditional Indian meals (Idli, Dosa, Poha, Dal Rice, Rajma, Chole Bhature, Biryani, Samosa, Chaat, etc.) with nutritional data
- Indian exercises: Yoga (Surya Namaskar, Pranayama), sports (Cricket, Badminton, Kabaddi), traditional activities
- Ayurvedic sleep tips, regional preferences, cultural meal timing

### 9. 🗺️ Journey Map
- Visual route and progress
- Weekly progress, milestones, achievements
- Distance and activity metrics

### 10. 📈 Gamification
- Points for every action
- Level progression
- Daily login streaks
- Achievements: First Entry, Week Warrior, Protein Pro, Workout Hero, 10K Steps, Early Bird, Sleep Master, Streak Master
- Visual achievement cards and celebrations

### 11. 💾 Data Persistence
- User profile, food entries, exercise logs, statistics, steps, theme saved locally
- Data survives app restarts
- No backend required; privacy-first

### 12. 📊 Comprehensive Tracking
- **Nutrition**: Calories, protein, carbs, fat, fiber; meal-wise (Breakfast, Lunch, Dinner, Snacks); daily totals vs goals
- **Exercise**: Duration, calories burned, types (cardio, strength, yoga, sports); active minutes; weekly trends
- **Sleep**: Duration, quality, bedtime/wake time, sleep score, tips
- **Activity**: Steps, distance, calories burned, active minutes

### 13. 🎨 Blue brand & UI
- **Blue-themed** app: primary and secondary blues across all tabs and buttons
- Unified, recognizable look for a future brand/marketing
- Card-based layouts; dynamic, youth-focused UI
- Consistent spacing, typography, icons
- Smooth animations and gradient accents

### 14. 🔄 Real-time Updates
- Dynamic calculations, live progress bars
- Instant UI updates and smooth transitions

### 15. 📅 Today vs Historical Data
- Dashboard shows today; historical preserved
- Weekly/monthly reports and trend analysis
- Date-specific queries; no duplicate counting

---

## How to Use

### Getting Started
1. **First visit**: Complete onboarding with your details (if shown).
2. **Main dashboard (Home)**: View today’s stats at a glance.
3. **Start tracking steps**: Use “Start Step Tracking” on the dashboard.
4. **Add food**: Tap “Log Food” → choose meal or custom entry.
5. **Add exercise**: Tap “Log Exercise” → choose activity.
6. **View AI tips**: Open the **AI** tab for recommendations.
7. **Edit profile**: Tap user icon (top-right) to manage data.
8. **Toggle theme**: Use sun/moon icon in the header.

### Navigation
- **Home**: Overall dashboard with today’s summary.
- **Workout**: Exercise log and library.
- **Food**: Nutrition log and goals.
- **Progress**: Journey map, routes, milestones.
- **AI**: Gamification and smart recommendations.
- **Profile**: Profile, settings, about & features.

### Features to Try
1. Track 10,000 steps to unlock the step achievement.
2. Log 3 meals to see daily challenge completion.
3. Try different diet plans (Keto, Vegan, etc.) in profile.
4. Explore time-based AI recommendations.
5. Build your streak by logging daily.
6. Switch to dark mode for night use.

---

## Technical (Flutter)

- **Flutter** with Dart
- **Provider** for theme state
- **Lucide Icons**
- Local storage for persistence
- Material 3, responsive layout

---

## Notes

- All data is stored locally (privacy-first).
- No backend/API required.
- Theme preference persists.
- Mobile-optimized; culturally relevant content for Indian users.
