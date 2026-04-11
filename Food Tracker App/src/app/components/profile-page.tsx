import { X, Save, User as UserIcon, Mail, Phone, Ruler, Weight, Target, Moon, Sun } from 'lucide-react';
import { useState, useEffect } from 'react';
import { useTheme } from './theme-provider';

interface UserProfile {
  name: string;
  age: number;
  gender: 'male' | 'female' | 'other';
  height: number;
  weight: number;
  activityLevel: 'sedentary' | 'light' | 'moderate' | 'active' | 'very-active';
  dietPlan: 'balanced' | 'keto' | 'low-carb' | 'high-protein' | 'vegan' | 'paleo';
  goal: 'lose-weight' | 'maintain' | 'gain-muscle' | 'improve-fitness';
  email?: string;
  phone?: string;
}

interface ProfilePageProps {
  isOpen: boolean;
  onClose: () => void;
  profile: UserProfile;
  onUpdateProfile: (profile: UserProfile) => void;
}

export function ProfilePage({ isOpen, onClose, profile, onUpdateProfile }: ProfilePageProps) {
  const [editedProfile, setEditedProfile] = useState<UserProfile>(profile);
  const [isEditing, setIsEditing] = useState(false);
  const { theme, toggleTheme } = useTheme();

  useEffect(() => {
    setEditedProfile(profile);
  }, [profile]);

  if (!isOpen) return null;

  const handleSave = () => {
    onUpdateProfile(editedProfile);
    setIsEditing(false);
  };

  const calculateBMI = () => {
    return (editedProfile.weight / Math.pow(editedProfile.height / 100, 2)).toFixed(1);
  };

  const getBMICategory = (bmi: number) => {
    if (bmi < 18.5) return { label: 'Underweight', color: 'text-blue-600 dark:text-blue-400' };
    if (bmi < 25) return { label: 'Normal', color: 'text-green-600 dark:text-green-400' };
    if (bmi < 30) return { label: 'Overweight', color: 'text-amber-600 dark:text-amber-400' };
    return { label: 'Obese', color: 'text-red-600 dark:text-red-400' };
  };

  const bmi = parseFloat(calculateBMI());
  const bmiCategory = getBMICategory(bmi);

  return (
    <div className="fixed inset-0 bg-black/50 flex items-end sm:items-center justify-center z-50">
      <div className="bg-white dark:bg-gray-800 rounded-t-3xl sm:rounded-3xl w-full sm:max-w-2xl max-h-[90vh] overflow-y-auto">
        <div className="sticky top-0 bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700 px-6 py-4 flex items-center justify-between rounded-t-3xl">
          <h2 className="text-xl font-semibold text-gray-900 dark:text-white">Profile & Settings</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-full transition-colors"
          >
            <X className="w-5 h-5 text-gray-600 dark:text-gray-300" />
          </button>
        </div>

        <div className="p-6 space-y-6">
          {/* Profile Picture & Basic Info */}
          <div className="text-center">
            <div className="w-24 h-24 bg-gradient-to-br from-orange-500 to-pink-500 rounded-full mx-auto mb-4 flex items-center justify-center">
              <UserIcon className="w-12 h-12 text-white" />
            </div>
            <h3 className="text-xl font-bold text-gray-900 dark:text-white">{editedProfile.name}</h3>
            <p className="text-sm text-gray-600 dark:text-gray-400 capitalize">{editedProfile.gender} • {editedProfile.age} years</p>
          </div>

          {/* Theme Toggle */}
          <div className="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                {theme === 'dark' ? (
                  <Moon className="w-5 h-5 text-indigo-600 dark:text-indigo-400" />
                ) : (
                  <Sun className="w-5 h-5 text-amber-600" />
                )}
                <div>
                  <div className="font-medium text-gray-900 dark:text-white">Theme</div>
                  <div className="text-xs text-gray-600 dark:text-gray-400">
                    {theme === 'dark' ? 'Dark Mode' : 'Light Mode'}
                  </div>
                </div>
              </div>
              <button
                onClick={toggleTheme}
                className="relative inline-flex h-8 w-14 items-center rounded-full transition-colors focus:outline-none focus:ring-2 focus:ring-orange-500 focus:ring-offset-2 dark:focus:ring-offset-gray-800 bg-gray-300 dark:bg-orange-600"
              >
                <span
                  className={`inline-block h-6 w-6 transform rounded-full bg-white transition-transform ${
                    theme === 'dark' ? 'translate-x-7' : 'translate-x-1'
                  }`}
                />
              </button>
            </div>
          </div>

          {/* BMI Card */}
          <div className="bg-gradient-to-br from-orange-50 to-amber-50 dark:from-orange-900/20 dark:to-amber-900/20 border border-orange-200 dark:border-orange-800 rounded-xl p-4">
            <div className="flex items-center justify-between mb-2">
              <div className="text-sm font-medium text-gray-700 dark:text-gray-300">Body Mass Index</div>
              <div className={`text-xs font-medium ${bmiCategory.color}`}>{bmiCategory.label}</div>
            </div>
            <div className="text-3xl font-bold text-orange-700 dark:text-orange-400">{bmi}</div>
          </div>

          {/* Personal Information */}
          <div className="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-4 space-y-4">
            <div className="flex items-center justify-between mb-2">
              <h4 className="font-semibold text-gray-900 dark:text-white">Personal Information</h4>
              <button
                onClick={() => setIsEditing(!isEditing)}
                className="text-sm text-orange-600 dark:text-orange-400 hover:text-orange-700 dark:hover:text-orange-300 font-medium"
              >
                {isEditing ? 'Cancel' : 'Edit'}
              </button>
            </div>

            {isEditing ? (
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Name</label>
                  <input
                    type="text"
                    value={editedProfile.name}
                    onChange={(e) => setEditedProfile({ ...editedProfile, name: e.target.value })}
                    className="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500 bg-white dark:bg-gray-800 text-gray-900 dark:text-white"
                  />
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Age</label>
                    <input
                      type="number"
                      value={editedProfile.age}
                      onChange={(e) => setEditedProfile({ ...editedProfile, age: parseInt(e.target.value) })}
                      className="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500 bg-white dark:bg-gray-800 text-gray-900 dark:text-white"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Gender</label>
                    <select
                      value={editedProfile.gender}
                      onChange={(e) => setEditedProfile({ ...editedProfile, gender: e.target.value as any })}
                      className="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500 bg-white dark:bg-gray-800 text-gray-900 dark:text-white"
                    >
                      <option value="male">Male</option>
                      <option value="female">Female</option>
                      <option value="other">Other</option>
                    </select>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Height (cm)</label>
                    <input
                      type="number"
                      value={editedProfile.height}
                      onChange={(e) => setEditedProfile({ ...editedProfile, height: parseInt(e.target.value) })}
                      className="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500 bg-white dark:bg-gray-800 text-gray-900 dark:text-white"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Weight (kg)</label>
                    <input
                      type="number"
                      value={editedProfile.weight}
                      onChange={(e) => setEditedProfile({ ...editedProfile, weight: parseInt(e.target.value) })}
                      className="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500 bg-white dark:bg-gray-800 text-gray-900 dark:text-white"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Email (Optional)</label>
                  <input
                    type="email"
                    value={editedProfile.email || ''}
                    onChange={(e) => setEditedProfile({ ...editedProfile, email: e.target.value })}
                    className="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500 bg-white dark:bg-gray-800 text-gray-900 dark:text-white"
                    placeholder="your@email.com"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Phone (Optional)</label>
                  <input
                    type="tel"
                    value={editedProfile.phone || ''}
                    onChange={(e) => setEditedProfile({ ...editedProfile, phone: e.target.value })}
                    className="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500 bg-white dark:bg-gray-800 text-gray-900 dark:text-white"
                    placeholder="+91 XXXXX XXXXX"
                  />
                </div>

                <button
                  onClick={handleSave}
                  className="w-full px-4 py-3 bg-orange-600 text-white rounded-xl hover:bg-orange-700 transition-colors font-medium flex items-center justify-center gap-2"
                >
                  <Save className="w-4 h-4" />
                  Save Changes
                </button>
              </div>
            ) : (
              <div className="space-y-3">
                <div className="flex items-center gap-3 text-gray-700 dark:text-gray-300">
                  <Ruler className="w-5 h-5 text-orange-600 dark:text-orange-400" />
                  <span className="text-sm">Height: {editedProfile.height} cm</span>
                </div>
                <div className="flex items-center gap-3 text-gray-700 dark:text-gray-300">
                  <Weight className="w-5 h-5 text-orange-600 dark:text-orange-400" />
                  <span className="text-sm">Weight: {editedProfile.weight} kg</span>
                </div>
                {editedProfile.email && (
                  <div className="flex items-center gap-3 text-gray-700 dark:text-gray-300">
                    <Mail className="w-5 h-5 text-orange-600 dark:text-orange-400" />
                    <span className="text-sm">{editedProfile.email}</span>
                  </div>
                )}
                {editedProfile.phone && (
                  <div className="flex items-center gap-3 text-gray-700 dark:text-gray-300">
                    <Phone className="w-5 h-5 text-orange-600 dark:text-orange-400" />
                    <span className="text-sm">{editedProfile.phone}</span>
                  </div>
                )}
              </div>
            )}
          </div>

          {/* Goals & Preferences */}
          <div className="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-4 space-y-3">
            <h4 className="font-semibold text-gray-900 dark:text-white mb-2">Goals & Preferences</h4>
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-600 dark:text-gray-400">Goal</span>
                <span className="text-sm font-medium text-gray-900 dark:text-white capitalize">
                  {editedProfile.goal.replace('-', ' ')}
                </span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-600 dark:text-gray-400">Diet Plan</span>
                <span className="text-sm font-medium text-gray-900 dark:text-white capitalize">
                  {editedProfile.dietPlan.replace('-', ' ')}
                </span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-600 dark:text-gray-400">Activity Level</span>
                <span className="text-sm font-medium text-gray-900 dark:text-white capitalize">
                  {editedProfile.activityLevel.replace('-', ' ')}
                </span>
              </div>
            </div>
          </div>

          {/* Data & Privacy */}
          <div className="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-4">
            <h4 className="font-semibold text-gray-900 dark:text-white mb-3">Data & Privacy</h4>
            <div className="space-y-2 text-sm text-gray-600 dark:text-gray-400">
              <p>• All your data is stored locally on your device</p>
              <p>• You have complete control over your information</p>
              <p>• No data is shared with third parties</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
