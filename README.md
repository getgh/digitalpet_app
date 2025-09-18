# digitalpet_app

A new Flutter project.

## I have improvised some of the logic other than the instructions. But all the functions are indeed working fine.

# Happiness Conditions:
- Increases by 10 when playing with pet
- Increases by 10 when feeding
- Decreases by 5 every 20 seconds if not played with for 30 seconds
- Decreases by 15 if hunger is high (> 80)
- Decreases by 10 if hunger is low (< 30)

# Hunger Conditions:
- Increases by 5 every 30 seconds automatically
- Increases by 5 when playing
- Decreases by 10 when feeding
- Clamped between 0-100

# Energy Conditions:
- Starts at 100
- Decreases by 10 when playing
- Increases by 5 when feeding
- Clamped between 0-100

# Win/Loss Conditions:
- Win: Happiness ≥ 80 AND Hunger ≤ 30
- Loss: Hunger ≥ 90 OR Happiness ≤ 10

# Pet Mood Colors:
- Green: Happiness > 70 (Happy 😊)
- Yellow: Happiness 30-70 (Neutral 😐)
- Red: Happiness < 30 (Unhappy 😢)