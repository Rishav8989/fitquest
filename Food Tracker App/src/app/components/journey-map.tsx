import { MapPin, Navigation, TrendingUp, Flag, Award } from 'lucide-react';
import { motion } from 'motion/react';
import { useState, useEffect } from 'react';

interface RoutePoint {
  lat: number;
  lng: number;
  timestamp: Date;
}

interface JourneyMapProps {
  totalSteps: number;
  totalDistance: number;
  activeMinutes: number;
}

export function JourneyMap({ totalSteps, totalDistance, activeMinutes }: JourneyMapProps) {
  const [isTracking, setIsTracking] = useState(false);
  const [currentRoute, setCurrentRoute] = useState<RoutePoint[]>([]);

  // Simulated popular Indian routes/locations
  const popularRoutes = [
    { name: 'Morning Walk', location: 'Local Park', distance: 2.5, time: 25, icon: '🌳' },
    { name: 'Evening Jog', location: 'Society Track', distance: 3.2, time: 30, icon: '🏃' },
    { name: 'Yoga Session', location: 'Home', distance: 0, time: 45, icon: '🧘' },
    { name: 'Badminton', location: 'Sports Complex', distance: 1.5, time: 60, icon: '🏸' },
  ];

  const weeklyProgress = [
    { day: 'Mon', distance: 4.2, calories: 320 },
    { day: 'Tue', distance: 5.1, calories: 380 },
    { day: 'Wed', distance: 3.8, calories: 290 },
    { day: 'Thu', distance: 6.2, calories: 450 },
    { day: 'Fri', distance: 4.9, calories: 370 },
    { day: 'Sat', distance: 7.3, calories: 520 },
    { day: 'Sun', distance: totalDistance, calories: Math.round(totalDistance * 65) },
  ];

  const milestones = [
    { id: 1, name: '5 km in a week', achieved: true, icon: '🎯' },
    { id: 2, name: '10,000 steps daily', achieved: totalSteps >= 10000, icon: '👟' },
    { id: 3, name: '30 min active daily', achieved: activeMinutes >= 30, icon: '⏱️' },
    { id: 4, name: '50 km total', achieved: false, icon: '🏆' },
  ];

  const startTracking = () => {
    setIsTracking(true);
    // In a real app, this would use the Geolocation API
  };

  const stopTracking = () => {
    setIsTracking(false);
  };

  return (
    <div className="space-y-4">
      {/* Map Placeholder with Tracking */}
      <div className="bg-white rounded-2xl overflow-hidden border border-gray-200">
        <div className="relative h-64 bg-gradient-to-br from-green-100 via-green-50 to-blue-50">
          {/* Simulated Map */}
          <div className="absolute inset-0 flex items-center justify-center">
            <div className="text-center">
              <MapPin className="w-12 h-12 text-orange-600 mx-auto mb-2 animate-bounce" />
              <div className="text-sm font-medium text-gray-700">Track Your Journey</div>
              <div className="text-xs text-gray-500">Real-time route tracking</div>
            </div>
          </div>

          {/* Route Path Visualization */}
          <svg className="absolute inset-0 w-full h-full pointer-events-none">
            <motion.path
              d="M 50 200 Q 100 150, 150 180 T 250 160 T 350 140"
              stroke="#fb923c"
              strokeWidth="3"
              fill="none"
              strokeLinecap="round"
              initial={{ pathLength: 0 }}
              animate={{ pathLength: isTracking ? 1 : 0.5 }}
              transition={{ duration: 2, ease: "easeInOut" }}
              strokeDasharray="5,5"
            />
          </svg>

          {/* Live Stats Overlay */}
          <div className="absolute top-4 left-4 right-4 flex justify-between">
            <div className="bg-white/90 backdrop-blur-sm rounded-xl px-3 py-2 shadow-sm">
              <div className="text-xs text-gray-600">Distance</div>
              <div className="text-lg font-bold text-gray-900">{totalDistance.toFixed(1)} km</div>
            </div>
            <div className="bg-white/90 backdrop-blur-sm rounded-xl px-3 py-2 shadow-sm">
              <div className="text-xs text-gray-600">Active</div>
              <div className="text-lg font-bold text-gray-900">{activeMinutes} min</div>
            </div>
          </div>

          {/* Tracking Button */}
          <div className="absolute bottom-4 left-1/2 -translate-x-1/2">
            <button
              onClick={isTracking ? stopTracking : startTracking}
              className={`px-6 py-3 rounded-full font-medium shadow-lg transition-all ${
                isTracking
                  ? 'bg-red-600 hover:bg-red-700 text-white'
                  : 'bg-orange-600 hover:bg-orange-700 text-white'
              }`}
            >
              <div className="flex items-center gap-2">
                <Navigation className={`w-4 h-4 ${isTracking ? 'animate-pulse' : ''}`} />
                {isTracking ? 'Stop Tracking' : 'Start Tracking'}
              </div>
            </button>
          </div>
        </div>
      </div>

      {/* Popular Routes */}
      <div className="bg-white rounded-2xl p-6 border border-gray-200">
        <h3 className="font-semibold text-gray-900 mb-4">Your Favorite Routes</h3>
        <div className="space-y-3">
          {popularRoutes.map((route, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: index * 0.1 }}
              className="flex items-center justify-between p-3 bg-gradient-to-r from-orange-50 to-amber-50 rounded-xl border border-orange-100"
            >
              <div className="flex items-center gap-3">
                <div className="text-2xl">{route.icon}</div>
                <div>
                  <div className="font-medium text-gray-900 text-sm">{route.name}</div>
                  <div className="text-xs text-gray-600">{route.location}</div>
                </div>
              </div>
              <div className="text-right">
                {route.distance > 0 && (
                  <div className="text-sm font-medium text-gray-900">{route.distance} km</div>
                )}
                <div className="text-xs text-gray-600">{route.time} min</div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>

      {/* Weekly Progress Graph */}
      <div className="bg-white rounded-2xl p-6 border border-gray-200">
        <div className="flex items-center justify-between mb-4">
          <h3 className="font-semibold text-gray-900">Weekly Progress</h3>
          <TrendingUp className="w-5 h-5 text-green-600" />
        </div>
        <div className="flex items-end justify-between gap-2 h-32">
          {weeklyProgress.map((day, index) => {
            const maxDistance = Math.max(...weeklyProgress.map(d => d.distance));
            const heightPercent = (day.distance / maxDistance) * 100;
            const isToday = index === weeklyProgress.length - 1;

            return (
              <div key={day.day} className="flex-1 flex flex-col items-center gap-2">
                <motion.div
                  initial={{ height: 0 }}
                  animate={{ height: `${heightPercent}%` }}
                  transition={{ delay: index * 0.1, duration: 0.5 }}
                  className={`w-full rounded-t-lg ${
                    isToday
                      ? 'bg-gradient-to-t from-orange-500 to-orange-400'
                      : 'bg-gradient-to-t from-orange-200 to-orange-100'
                  }`}
                  title={`${day.distance} km`}
                />
                <div className="text-xs font-medium text-gray-600">{day.day}</div>
              </div>
            );
          })}
        </div>
        <div className="mt-4 pt-4 border-t border-gray-200">
          <div className="flex items-center justify-between text-sm">
            <div>
              <span className="text-gray-600">Weekly Total: </span>
              <span className="font-semibold text-gray-900">
                {weeklyProgress.reduce((sum, day) => sum + day.distance, 0).toFixed(1)} km
              </span>
            </div>
            <div>
              <span className="text-gray-600">Calories: </span>
              <span className="font-semibold text-orange-600">
                {weeklyProgress.reduce((sum, day) => sum + day.calories, 0)}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Journey Milestones */}
      <div className="bg-white rounded-2xl p-6 border border-gray-200">
        <div className="flex items-center gap-2 mb-4">
          <Flag className="w-5 h-5 text-orange-600" />
          <h3 className="font-semibold text-gray-900">Journey Milestones</h3>
        </div>
        <div className="space-y-3">
          {milestones.map((milestone) => (
            <div
              key={milestone.id}
              className={`flex items-center justify-between p-3 rounded-xl border-2 transition-all ${
                milestone.achieved
                  ? 'bg-green-50 border-green-200'
                  : 'bg-gray-50 border-gray-200'
              }`}
            >
              <div className="flex items-center gap-3">
                <div className={`text-2xl ${milestone.achieved ? '' : 'grayscale opacity-50'}`}>
                  {milestone.icon}
                </div>
                <div className="font-medium text-sm text-gray-900">{milestone.name}</div>
              </div>
              {milestone.achieved ? (
                <Award className="w-5 h-5 text-green-600" />
              ) : (
                <div className="text-xs text-gray-500">In progress</div>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
