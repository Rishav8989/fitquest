import json

def generate():
    foods = []
    # Indian foods base
    bases = [
        ("Idli", 40, 1, 8, 0, 1),
        ("Dosa", 120, 2, 20, 3, 2),
        ("Poha", 200, 4, 35, 6, 3),
        ("Upma", 180, 4, 30, 5, 2),
        ("Paratha", 250, 6, 35, 8, 3),
        ("Aloo Paratha", 300, 7, 40, 10, 4),
        ("Paneer Paratha", 350, 12, 35, 15, 3),
        ("Roti", 80, 2, 15, 1, 2),
        ("Naan", 150, 4, 25, 4, 1),
        ("Dal Makhani", 300, 15, 35, 12, 8),
        ("Yellow Dal", 200, 10, 30, 4, 6),
        ("Rajma", 250, 12, 40, 5, 8),
        ("Chole", 280, 12, 45, 6, 8),
        ("Butter Chicken", 400, 25, 15, 25, 2),
        ("Chicken Tikka", 250, 30, 5, 12, 1),
        ("Palak Paneer", 320, 18, 15, 22, 5),
        ("Shahi Paneer", 380, 15, 20, 25, 3),
        ("Biryani (Chicken)", 500, 25, 60, 15, 3),
        ("Biryani (Veg)", 400, 10, 65, 12, 5),
        ("Samosa", 150, 2, 18, 8, 2),
        ("Kachori", 200, 3, 22, 12, 2),
        ("Gulab Jamun", 150, 2, 25, 5, 0),
        ("Jalebi", 200, 1, 40, 6, 0),
        ("Lassi (Sweet)", 250, 8, 35, 8, 0),
        ("Buttermilk", 50, 3, 4, 2, 0),
    ]

    portions = [
        ("0.5", 0.5, "half serving"),
        ("1", 1, "1 serving"),
        ("1.5", 1.5, "1.5 servings"),
        ("2", 2, "2 servings"),
        ("3", 3, "3 servings"),
        ("Bowl", 1.2, "1 bowl"),
        ("Large Portion", 1.8, "Large"),
    ]

    for b in bases:
        for p in portions:
            foods.append({
                "name": f"{b[0]} ({p[2]})",
                "calories": int(b[1] * p[1]),
                "protein": int(b[2] * p[1]),
                "carbs": int(b[3] * p[1]),
                "fat": int(b[4] * p[1]),
                "fiber": int(b[5] * p[1]),
                "serving": p[2]
            })

    # Generic globally
    global_bases = [
        ("Apple", 95, 0, 25, 0, 4),
        ("Banana", 105, 1, 27, 0, 3),
        ("Chicken Breast", 165, 31, 0, 3, 0),
        ("Boiled Egg", 78, 6, 0, 5, 0),
        ("Rice (White)", 205, 4, 45, 0, 0),
        ("Rice (Brown)", 215, 5, 45, 1, 3),
        ("Oats", 150, 5, 27, 3, 4),
        ("Almonds", 160, 6, 6, 14, 3),
        ("Walnuts", 180, 4, 4, 18, 2),
        ("Peanut Butter", 190, 7, 6, 16, 2),
        ("Whey Protein", 120, 24, 3, 1, 0),
        ("Greek Yogurt", 100, 10, 4, 0, 0),
        ("Milk (Whole)", 150, 8, 12, 8, 0),
        ("Potato", 130, 3, 30, 0, 3),
        ("Sweet Potato", 100, 2, 23, 0, 3),
        ("Broccoli", 50, 3, 10, 0, 5),
    ]

    for b in global_bases:
        for i in range(1, 6):
            foods.append({
                "name": f"{b[0]} ({i * 100}g)",
                "calories": int(b[1] * i),
                "protein": int(b[2] * i),
                "carbs": int(b[3] * i),
                "fat": int(b[4] * i),
                "fiber": int(b[5] * i),
                "serving": f"{i * 100}g"
            })

    exercises = []
    ex_bases = [
        ("Running", "Cardio", 10),
        ("Cycling", "Cardio", 8),
        ("Swimming", "Cardio", 9),
        ("Jump Rope", "Cardio", 12),
        ("Brisk Walking", "Cardio", 5),
        ("Jogging", "Cardio", 7),
        ("Push-ups", "Strength", 6),
        ("Pull-ups", "Strength", 8),
        ("Squats", "Strength", 5),
        ("Deadlifts", "Strength", 7),
        ("Bench Press", "Strength", 5),
        ("Overhead Press", "Strength", 4),
        ("Bicep Curls", "Strength", 3),
        ("Tricep Extensions", "Strength", 3),
        ("Plank", "Strength", 4),
        ("Crunches", "Strength", 4),
        ("Yoga", "Flexibility", 3),
        ("Stretching", "Flexibility", 2),
        ("Pilates", "Flexibility", 4),
        ("HIIT", "Cardio", 14),
    ]

    for b in ex_bases:
        for d in [10, 15, 20, 30, 45, 60, 90]:
            exercises.append({
                "name": f"{b[0]} for {d} mins",
                "baseName": b[0],
                "type": b[1],
                "duration": d,
                "calories": b[2] * d
            })

    # Output to massive_datasets.dart
    with open('/home/server/etc/fitquest/lib/data/massive_datasets.dart', 'w') as f:
        f.write("class MassiveDatasets {\n")
        
        # Write foods
        f.write("  static const List<Map<String, dynamic>> foods = [\n")
        count = 0
        for food in foods:
            f.write(f"    {food},\n")
            count += 1
        f.write("  ];\n\n")

        # Write exercises
        f.write("  static const List<Map<String, dynamic>> exercises = [\n")
        for ex in exercises:
            f.write(f"    {ex},\n")
        f.write("  ];\n")
        
        f.write("}\n")
    print(f"Generated {count} foods and {len(exercises)} exercises.")

if __name__ == '__main__':
    generate()
