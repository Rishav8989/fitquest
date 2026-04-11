import { useState } from 'react';
import { X, User, Target, Calendar } from 'lucide-react';

interface UserProfile {
  name: string;
  age: number;
  gender: 'male' | 'female' | 'other';
  height: number;
  weight: number;
  activityLevel: 'sedentary' | 'light' | 'moderate' | 'active' | 'very-active';
  dietPlan: 'balanced' | 'keto' | 'low-carb' | 'high-protein' | 'vegan' | 'paleo';
  goal: 'lose-weight' | 'maintain' | 'gain-muscle' | 'improve-fitness';
}

interface OnboardingProps {
  onComplete: (profile: UserProfile) => void;
}

export function Onboarding({ onComplete }: OnboardingProps) {
  const [step, setStep] = useState(1);
  const [profile, setProfile] = useState<UserProfile>({
    name: '',
    age: 0,
    gender: 'male',
    height: 170,
    weight: 70,
    activityLevel: 'moderate',
    dietPlan: 'balanced',
    goal: 'maintain'
  });

  const handleNext = () => {
    if (step < 4) {
      setStep(step + 1);
    } else {
      onComplete(profile);
    }
  };

  const handleBack = () => {
    if (step > 1) {
      setStep(step - 1);
    }
  };

  return (
    <div className="fixed inset-0 bg-gradient-to-br from-emerald-500 to-teal-600 flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-3xl max-w-md w-full shadow-2xl overflow-hidden">
        <div className="bg-gradient-to-r from-emerald-600 to-teal-600 px-6 py-8 text-white">
          <div className="text-center mb-6">
            <div className="text-6xl mb-4">🎯</div>
            <h2 className="text-2xl font-bold mb-2">Welcome to NutriQuest</h2>
            <p className="text-sm opacity-90">Let's personalize your health journey</p>
          </div>
          <div className="flex gap-2">
            {[1, 2, 3, 4].map((s) => (
              <div
                key={s}
                className={`flex-1 h-1.5 rounded-full transition-all ${
                  s <= step ? 'bg-white' : 'bg-white/30'
                }`}
              />
            ))}
          </div>
        </div>

        <div className="p-6">
          {step === 1 && (
            <div className="space-y-6">
              <div>
                <h3 className="text-xl font-bold text-gray-900 mb-2">Basic Information</h3>
                <p className="text-sm text-gray-600">Help us understand you better</p>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  What's your name?
                </label>
                <input
                  type="text"
                  value={profile.name}
                  onChange={(e) => setProfile({ ...profile, name: e.target.value })}
                  className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-emerald-500"
                  placeholder="Enter your name"
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Age
                  </label>
                  <input
                    type="number"
                    value={profile.age || ''}
                    onChange={(e) => setProfile({ ...profile, age: parseInt(e.target.value) || 0 })}
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-emerald-500"
                    placeholder="25"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Gender
                  </label>
                  <select
                    value={profile.gender}
                    onChange={(e) => setProfile({ ...profile, gender: e.target.value as any })}
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-emerald-500"
                  >
                    <option value="male">Male</option>
                    <option value="female">Female</option>
                    <option value="other">Other</option>
                  </select>
                </div>
              </div>
            </div>
          )}

          {step === 2 && (
            <div className="space-y-6">
              <div>
                <h3 className="text-xl font-bold text-gray-900 mb-2">Body Metrics</h3>
                <p className="text-sm text-gray-600">Your physical measurements</p>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Height (cm)
                </label>
                <input
                  type="number"
                  value={profile.height}
                  onChange={(e) => setProfile({ ...profile, height: parseInt(e.target.value) || 0 })}
                  className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-emerald-500"
                  placeholder="170"
                />
                <p className="text-xs text-gray-500 mt-1">
                  Current: {(profile.height / 30.48).toFixed(1)} feet
                </p>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Weight (kg)
                </label>
                <input
                  type="number"
                  value={profile.weight}
                  onChange={(e) => setProfile({ ...profile, weight: parseInt(e.target.value) || 0 })}
                  className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-emerald-500"
                  placeholder="70"
                />
                <p className="text-xs text-gray-500 mt-1">
                  Current: {(profile.weight * 2.20462).toFixed(1)} lbs
                </p>
              </div>

              {profile.height > 0 && profile.weight > 0 && (
                <div className="bg-emerald-50 border border-emerald-200 rounded-xl p-4">
                  <div className="text-sm text-gray-600 mb-1">Your BMI</div>
                  <div className="text-2xl font-bold text-emerald-700">
                    {(profile.weight / Math.pow(profile.height / 100, 2)).toFixed(1)}
                  </div>
                </div>
              )}
            </div>
          )}

          {step === 3 && (
            <div className="space-y-6">
              <div>
                <h3 className="text-xl font-bold text-gray-900 mb-2">Activity & Diet</h3>
                <p className="text-sm text-gray-600">Your lifestyle preferences</p>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  Activity Level
                </label>
                <div className="space-y-2">
                  {[
                    { value: 'sedentary', label: 'Sedentary', desc: 'Little or no exercise' },
                    { value: 'light', label: 'Light', desc: '1-3 days/week' },
                    { value: 'moderate', label: 'Moderate', desc: '3-5 days/week' },
                    { value: 'active', label: 'Active', desc: '6-7 days/week' },
                    { value: 'very-active', label: 'Very Active', desc: 'Intense daily exercise' }
                  ].map((option) => (
                    <button
                      key={option.value}
                      onClick={() => setProfile({ ...profile, activityLevel: option.value as any })}
                      className={`w-full p-4 rounded-xl border-2 transition-all text-left ${
                        profile.activityLevel === option.value
                          ? 'border-emerald-500 bg-emerald-50'
                          : 'border-gray-200 hover:border-gray-300'
                      }`}
                    >
                      <div className="font-medium text-gray-900">{option.label}</div>
                      <div className="text-sm text-gray-500">{option.desc}</div>
                    </button>
                  ))}
                </div>
              </div>
            </div>
          )}

          {step === 4 && (
            <div className="space-y-6">
              <div>
                <h3 className="text-xl font-bold text-gray-900 mb-2">Goals & Diet Plan</h3>
                <p className="text-sm text-gray-600">Choose your path to success</p>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  Primary Goal
                </label>
                <div className="grid grid-cols-2 gap-3">
                  {[
                    { value: 'lose-weight', label: 'Lose Weight', icon: '📉' },
                    { value: 'maintain', label: 'Maintain', icon: '⚖️' },
                    { value: 'gain-muscle', label: 'Gain Muscle', icon: '💪' },
                    { value: 'improve-fitness', label: 'Get Fit', icon: '🏃' }
                  ].map((option) => (
                    <button
                      key={option.value}
                      onClick={() => setProfile({ ...profile, goal: option.value as any })}
                      className={`p-4 rounded-xl border-2 transition-all ${
                        profile.goal === option.value
                          ? 'border-emerald-500 bg-emerald-50'
                          : 'border-gray-200 hover:border-gray-300'
                      }`}
                    >
                      <div className="text-3xl mb-2">{option.icon}</div>
                      <div className="text-sm font-medium text-gray-900">{option.label}</div>
                    </button>
                  ))}
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  Diet Plan
                </label>
                <div className="grid grid-cols-2 gap-3">
                  {[
                    { value: 'balanced', label: 'Balanced', icon: '🥗' },
                    { value: 'keto', label: 'Keto', icon: '🥑' },
                    { value: 'low-carb', label: 'Low Carb', icon: '🥩' },
                    { value: 'high-protein', label: 'High Protein', icon: '🍗' },
                    { value: 'vegan', label: 'Vegan', icon: '🌱' },
                    { value: 'paleo', label: 'Paleo', icon: '🦴' }
                  ].map((option) => (
                    <button
                      key={option.value}
                      onClick={() => setProfile({ ...profile, dietPlan: option.value as any })}
                      className={`p-3 rounded-xl border-2 transition-all ${
                        profile.dietPlan === option.value
                          ? 'border-emerald-500 bg-emerald-50'
                          : 'border-gray-200 hover:border-gray-300'
                      }`}
                    >
                      <div className="text-2xl mb-1">{option.icon}</div>
                      <div className="text-xs font-medium text-gray-900">{option.label}</div>
                    </button>
                  ))}
                </div>
              </div>
            </div>
          )}
        </div>

        <div className="px-6 pb-6 flex gap-3">
          {step > 1 && (
            <button
              onClick={handleBack}
              className="flex-1 px-6 py-3 border border-gray-300 rounded-xl hover:bg-gray-50 transition-colors font-medium"
            >
              Back
            </button>
          )}
          <button
            onClick={handleNext}
            disabled={step === 1 && !profile.name}
            className="flex-1 px-6 py-3 bg-emerald-600 text-white rounded-xl hover:bg-emerald-700 transition-colors font-medium disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {step === 4 ? 'Start Journey' : 'Continue'}
          </button>
        </div>
      </div>
    </div>
  );
}
