Config = {}

-- Welcome Ped Configuration
Config.WelcomePed = {
    coords = vector4(-1439.05, -552.42, 34.74, 29.45),
    model = "a_f_y_hipster_01", -- Female hipster model
    fallbackModel = "a_f_y_business_01", -- Fallback model if hipster fails
    scenario = "WORLD_HUMAN_GUARD_STAND", -- Standing animation
    waveAnimation = {
        dict = "friends@frj@ig_1",
        anim = "wave_b"
    },
    blip = {
        sprite = 280, -- Ped icon
        color = 5, -- Yellow
        scale = 0.8,
        name = "Welcome Center"
    }
}

-- Apartment location for GPS
Config.ApartmentLocation = vector3(-667.07, -1105.23, 14.63)

-- Messages
Config.Messages = {
    welcome = "Welcome! I'm here to help you get settled in.",
    apartmentInfo = "I've marked your new apartment on your GPS. It's just a short walk from here!",
    directions = "Head towards the apartment building I've marked on your map. You'll find your new home there.",
    gpsSet = "GPS route set to your apartment!",
    alreadyVisited = "Welcome back! Need anything else?"
}

-- Interaction settings
Config.InteractionDistance = 2.0
Config.InteractionIcon = "fa-solid fa-handshake"
Config.InteractionLabel = "Welcome to One Shot RP!" 