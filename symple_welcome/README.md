# Symple Welcome

A welcome ped system that greets new players and provides directions to their apartment using ox_target integration.

## Features

- **Welcome Ped**: Business man with clipboard animation
- **ox_target Integration**: Easy interaction with handshake icon
- **GPS Navigation**: Automatically sets waypoint to apartment
- **Dialog System**: Step-by-step welcome process
- **Blip System**: Shows welcome center location on map
- **One-time Interaction**: Players only get the full welcome once

## How It Works

1. **Player spawns** near the welcome center
2. **Player approaches** the welcome ped
3. **Player interacts** using ox_target (handshake icon)
4. **Welcome dialog** appears with Bandcamp introduction
5. **Apartment info** is provided
6. **GPS is set** to the apartment location
7. **Directions are given** to help player find their way

## Configuration

### Config.lua
- `Config.WelcomePed.coords`: Location of the welcome ped
- `Config.WelcomePed.model`: Ped model (business man)
- `Config.WelcomePed.scenario`: Animation (clipboard)
- `Config.ApartmentLocation`: GPS destination coordinates
- `Config.Messages`: All dialog and notification messages

## Requirements

- qb-core
- ox_target
- ox_lib

## Installation

1. Place this resource in your `resources/[standalone]/` folder
2. Add `ensure symple_welcome` to your server.cfg
3. Restart your server

## Commands

- `/testwelcome` - Admin command to test the welcome interaction
- `/spawnwelcomeped` - Manually respawn the welcome ped (for testing)

## Troubleshooting

### Welcome Ped Not Spawning
1. **Check console** for error messages
2. **Use `/spawnwelcomeped`** to manually spawn the ped
3. **Verify coordinates** are not inside a building or underground
4. **Check dependencies** are started (ox_target, ox_lib)
5. **Restart the resource** if needed

### Common Issues
- **Ped model not loading**: Script will try fallback model
- **ox_target not working**: Make sure ox_target is started before this resource
- **Coordinates issue**: Ped might spawn underground or inside objects

## Customization

### Change Ped Model
```lua
Config.WelcomePed.model = "a_m_m_business_01" -- Change to any ped model
```

### Change Animation
```lua
Config.WelcomePed.scenario = "WORLD_HUMAN_CLIPBOARD" -- Change to any scenario
```

### Change Messages
```lua
Config.Messages.welcome = "Your custom welcome message"
```

## Integration

This script works perfectly with the `new_player_setup` resource to provide a complete new player experience:

1. Player creates character
2. Player spawns near welcome center
3. Welcome ped provides directions
4. GPS guides player to apartment
5. Player can access their new home 