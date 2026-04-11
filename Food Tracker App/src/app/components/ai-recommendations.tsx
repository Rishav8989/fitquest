import { Sparkles, ChevronRight, Clock, Sun, Sunset, Moon as MoonIcon } from 'lucide-react';
import { motion } from 'motion/react';

interface AIRecommendationsProps {
  userProfile: {
    dietPlan: string;
    goal: string;
    activityLevel: string;
  };
  todayStats: {
    calories: number;
    protein: number;
    steps: number;
    sleep: number;
  };
  exercises: Array<{ type: string; duration: number; timestamp: Date }>;
}

export function AIRecommendations({ userProfile, todayStats, exercises }: AIRecommendationsProps) {
  const getCurrentTimeOfDay = () => {
    const hour = new Date().getHours();
    if (hour >= 5 && hour < 12) return 'morning';
    if (hour >= 12 && hour < 17) return 'afternoon';
    if (hour >= 17 && hour < 21) return 'evening';
    return 'night';
  };

  const timeOfDay = getCurrentTimeOfDay();

  const generateRecommendations = () => {
    const recommendations = [];
    const hour = new Date().getHours();

    // Time-based recommendations (Indian context)
    if (timeOfDay === 'morning' && todayStats.calories < 300) {
      recommendations.push({
        id: 'morning-meal',
        type: 'nutrition',
        title: 'Start Your Day Right',
        description: 'Have a healthy breakfast: Idli-sambar, poha, or upma with a glass of lassi. Ayurveda recommends eating within 2 hours of waking.',
        priority: 'high',
        icon: '🌅',
        timeContext: true
      });
    }

    if (timeOfDay === 'morning' && todayStats.steps < 1000) {
      recommendations.push({
        id: 'morning-walk',
        type: 'exercise',
        title: 'Morning Walk Time',
        description: 'Best time for Pranayama and brisk walking. Try a 30-minute walk in the park or do Surya Namaskar (Sun Salutation) at home.',
        priority: 'high',
        icon: '🚶',
        timeContext: true
      });
    }

    if (timeOfDay === 'afternoon' && hour >= 13 && hour <= 14) {
      recommendations.push({
        id: 'lunch-time',
        type: 'nutrition',
        title: 'Have Your Largest Meal Now',
        description: 'Ayurveda says lunch should be the biggest meal. Try: Dal-rice-sabzi-roti combo with curd. Your digestive fire (Agni) is strongest now.',
        priority: 'high',
        icon: '🍱',
        timeContext: true
      });
    }

    if (timeOfDay === 'afternoon' && todayStats.calories > 800) {
      recommendations.push({
        id: 'post-lunch-walk',
        type: 'exercise',
        title: '100 Steps After Lunch',
        description: 'Indian tradition: Walk 100 steps after meals. It aids digestion and prevents acidity. Try a short 5-minute walk.',
        priority: 'medium',
        icon: '🚶‍♂️',
        timeContext: true
      });
    }

    if (timeOfDay === 'evening' && hour >= 16 && hour <= 18) {
      recommendations.push({
        id: 'evening-snack',
        type: 'nutrition',
        title: 'Healthy Evening Snack',
        description: 'Try: Dhokla, chana chaat, roasted makhana, or masala chai with wheat rusks. Avoid heavy fried snacks.',
        priority: 'medium',
        icon: '☕',
        timeContext: true
      });
    }

    if (timeOfDay === 'evening' && exercises.length === 0) {
      recommendations.push({
        id: 'evening-yoga',
        type: 'exercise',
        title: 'Evening Yoga Session',
        description: 'Perfect time for yoga, badminton, or gym. Try evening walks at the park. Avoid intense cardio 3 hours before sleep.',
        priority: 'high',
        icon: '🧘',
        timeContext: true
      });
    }

    if (timeOfDay === 'night' && hour >= 20) {
      recommendations.push({
        id: 'light-dinner',
        type: 'nutrition',
        title: 'Light Dinner Recommended',
        description: 'Eat light: Khichdi, vegetable soup, or roti-sabzi. Finish dinner by 8 PM. Avoid curd at night (Ayurvedic principle).',
        priority: 'high',
        icon: '🌙',
        timeContext: true
      });
    }

    // Exercise type-based recommendations
    const lastExercise = exercises[exercises.length - 1];
    if (lastExercise && lastExercise.type === 'cardio') {
      recommendations.push({
        id: 'cardio-recovery',
        type: 'nutrition',
        title: 'Post-Cardio Nutrition',
        description: 'Replenish with coconut water, banana with peanut butter, or sprouted moong chaat. Protein within 30 minutes aids recovery.',
        priority: 'medium',
        icon: '🥤',
        timeContext: false
      });
    }

    if (lastExercise && lastExercise.type === 'strength') {
      recommendations.push({
        id: 'strength-protein',
        type: 'nutrition',
        title: 'Protein for Muscle Recovery',
        description: 'Have: Paneer bhurji, boiled eggs, dal, or protein shake. Aim for 20-30g protein post-workout for muscle repair.',
        priority: 'high',
        icon: '💪',
        timeContext: false
      });
    }

    // General health recommendations
    if (todayStats.protein < 50 && userProfile.goal === 'gain-muscle') {
      recommendations.push({
        id: 'protein-boost',
        type: 'nutrition',
        title: 'Increase Protein Intake',
        description: 'Indian protein sources: Paneer, dal, rajma, chole, eggs, chicken, fish. Add sprouts to breakfast and chana to snacks.',
        priority: 'high',
        icon: '🥚',
        timeContext: false
      });
    }

    if (todayStats.steps < 3000 && hour > 10) {
      recommendations.push({
        id: 'move-more',
        type: 'exercise',
        title: 'Get Moving!',
        description: 'Take stairs, do household chores, or play with kids. Indian traditional: Gardening, Rangoli making, or playing cricket.',
        priority: 'medium',
        icon: '🏃',
        timeContext: false
      });
    }

    if (todayStats.sleep < 7) {
      recommendations.push({
        id: 'sleep-priority',
        type: 'recovery',
        title: 'Prioritize Sleep Tonight',
        description: 'Ayurveda recommends 10 PM bedtime. Try: Warm milk with turmeric, avoid phone screens, and practice Shavasana before bed.',
        priority: 'high',
        icon: '😴',
        timeContext: false
      });
    }

    // Diet-specific recommendations
    if (userProfile.dietPlan === 'vegan') {
      recommendations.push({
        id: 'vegan-indian',
        type: 'nutrition',
        title: 'Vegan Indian Options',
        description: 'Try: Dal, rajma, chole, tofu bhurji, soya chunks curry, peanut chikki, or almond milk. Rich in plant protein.',
        priority: 'low',
        icon: '🌱',
        timeContext: false
      });
    }

    if (userProfile.dietPlan === 'keto') {
      recommendations.push({
        id: 'keto-indian',
        type: 'nutrition',
        title: 'Keto-Friendly Indian Foods',
        description: 'Focus on: Paneer tikka, butter chicken (no gravy), egg bhurji, coconut chutney, ghee, nuts, and green vegetables.',
        priority: 'low',
        icon: '🥑',
        timeContext: false
      });
    }

    // Goal-specific
    if (userProfile.goal === 'lose-weight') {
      recommendations.push({
        id: 'weight-loss',
        type: 'nutrition',
        title: 'Weight Loss Strategy',
        description: 'Indian tips: Jeera water morning, green tea, avoid white rice, use millets (ragi, jowar), eat salad before meals.',
        priority: 'medium',
        icon: '📉',
        timeContext: false
      });
    }

    // Traditional Indian wellness
    recommendations.push({
      id: 'ayurvedic-tip',
      type: 'wellness',
      title: 'Traditional Wellness Tip',
      description: 'Drink warm water throughout the day, add turmeric to milk, have tulsi tea, and practice oil pulling in the morning.',
      priority: 'low',
      icon: '🪔',
      timeContext: false
    });

    return recommendations.slice(0, 6);
  };

  const recommendations = generateRecommendations();

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'high': return 'bg-orange-50 border-orange-200';
      case 'medium': return 'bg-amber-50 border-amber-200';
      case 'low': return 'bg-green-50 border-green-200';
      default: return 'bg-gray-50 border-gray-200';
    }
  };

  const getPriorityDot = (priority: string) => {
    switch (priority) {
      case 'high': return 'bg-orange-500';
      case 'medium': return 'bg-amber-500';
      case 'low': return 'bg-green-500';
      default: return 'bg-gray-500';
    }
  };

  const getTimeIcon = () => {
    switch (timeOfDay) {
      case 'morning': return <Sun className="w-4 h-4 text-amber-500" />;
      case 'afternoon': return <Sun className="w-4 h-4 text-orange-500" />;
      case 'evening': return <Sunset className="w-4 h-4 text-orange-600" />;
      case 'night': return <MoonIcon className="w-4 h-4 text-indigo-500" />;
    }
  };

  return (
    <div className="bg-white rounded-2xl p-6 border border-gray-200">
      <div className="flex items-center gap-2 mb-4">
        <div className="bg-gradient-to-br from-orange-500 to-pink-500 rounded-lg p-2">
          <Sparkles className="w-5 h-5 text-white" />
        </div>
        <div className="flex-1">
          <h3 className="font-semibold text-gray-900">AI Coach</h3>
          <p className="text-xs text-gray-500">Personalized recommendations</p>
        </div>
        <div className="flex items-center gap-1 bg-gradient-to-r from-orange-50 to-amber-50 px-3 py-1.5 rounded-full border border-orange-200">
          {getTimeIcon()}
          <span className="text-xs font-medium text-gray-700 capitalize">{timeOfDay}</span>
        </div>
      </div>

      <div className="space-y-3">
        {recommendations.map((rec, index) => (
          <motion.div
            key={rec.id}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.1 }}
            className={`border rounded-xl p-4 ${getPriorityColor(rec.priority)}`}
          >
            <div className="flex items-start gap-3">
              <div className="text-2xl flex-shrink-0">{rec.icon}</div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-1 flex-wrap">
                  <div className={`w-2 h-2 rounded-full ${getPriorityDot(rec.priority)}`}></div>
                  <h4 className="font-medium text-gray-900 text-sm">{rec.title}</h4>
                  {rec.timeContext && (
                    <span className="inline-flex items-center gap-1 text-xs bg-white/60 px-2 py-0.5 rounded-full">
                      <Clock className="w-3 h-3" />
                      Now
                    </span>
                  )}
                </div>
                <p className="text-xs text-gray-600 leading-relaxed mb-2">{rec.description}</p>
                <div className="flex gap-2">
                  <span className="inline-flex items-center text-xs font-medium text-gray-700 bg-white/50 px-2 py-1 rounded-full">
                    {rec.type}
                  </span>
                  <span className="inline-flex items-center text-xs font-medium text-gray-700 bg-white/50 px-2 py-1 rounded-full capitalize">
                    {rec.priority}
                  </span>
                </div>
              </div>
              <ChevronRight className="w-4 h-4 text-gray-400 flex-shrink-0 mt-1" />
            </div>
          </motion.div>
        ))}
      </div>

      <div className="mt-4 p-4 bg-gradient-to-br from-orange-50 to-amber-50 border border-orange-200 rounded-xl">
        <div className="text-sm font-medium text-orange-900 mb-1">
          🇮🇳 Indian Wisdom
        </div>
        <div className="text-xs text-orange-700">
          {timeOfDay === 'morning' && "Early morning exercise strengthens immunity. Don't skip breakfast - it's the most important meal."}
          {timeOfDay === 'afternoon' && "Lunch should be your largest meal. Rest for 10 minutes after eating, then take a short walk."}
          {timeOfDay === 'evening' && "Evening is perfect for yoga and meditation. Avoid heavy meals after sunset for better digestion."}
          {timeOfDay === 'night' && "Light dinner 2-3 hours before bed. Warm milk with turmeric aids sleep. Practice gratitude before sleeping."}
        </div>
      </div>
    </div>
  );
}
