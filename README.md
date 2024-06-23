<p align="center">
  <img src="https://github.com/DrRetro2033/Pokemon-Manager/assets/86109384/1940527b-ad54-46b6-a371-ed560df0df4f" width="600" height="300" border="0"/>
</p>
<p align="center"> View, organize, and manage your Pokémon. </p>

### NOTICE: This new version is still in alpha, and does not have all of the features that PKHeX or the original version has.
What is Pokémon Manager?
-
Pokémon Manager is designed to be an alternative to [PKHeX](https://github.com/kwsch/PKHeX). The goal of this project is to make a user friendly, yet feature rich way to store your Pokémon. 

[What happened to the Godot Engine version of Pokémon Manager?](https://github.com/DrRetro2033/Pokemon-Manager)
-
That version of Pokémon Manager is now outdated. That version was messy, confusing, and had many workarounds. While I am proud of that version, I have grown a lot since that time, and have been learning from my mistakes. Some important lessons I learned was:

1. Document everything. Do not let comments and docstrings go to the wayside.
2. OOP (Object Oriented Programming) is a friend, and use it a lot more.
3. Fragment code into files. For example, enumerators should be in there own file rather than being strewn around multiple objects and classes.
4. Keep the frontend (The GUI and Menu logic) and the backend (Pokémon, Trainers, and vital functions) separated from each other. 
5. Always focus on the backend before the frontend.
## Goals/Planned Features:
 - [ ] Convertion between different generations.
 - [ ] Import/Export
    - [ ] Import and Export from and to Pokémon Showdown.
    - [ ] Exporting a single Pokémon or the entire library.
 - [ ] Trainer Support.
   - [ ] Editing Trainers.
 - [ ] Sharing with other People.
 - [ ] SQL Database to store Pokémon and Trainers.
    - [ ] The ability to restore a Pokémon in a save file.
 - [ ] File Support.
    - [ ] Encryption and Decryption.
    - [ ] Ability to edit files easily.
    - [ ] PKM File support.
        - [ ] pk1
        - [ ] pk2
        - [ ] pk3
        - [ ] pk4
        - [ ] pk5
        - [ ] pk6
        - [ ] pk7
        - [ ] pk8
        - [ ] pk9
    - [ ] Save File support.
        - [ ] sav
 - [ ] Experience Calculator.
 - [ ] Clean and Compact Pokémon Preview.
 - [ ] Stats chart with Base, IV, and EVs shown in total.
 - [ ] Drag and Droping.
 - [ ] Mobile Support:
    - [ ] Android.
    - [ ] IOS (Maybe)
 - [ ] PokéDex Entries.

## Contributing:
Please feel free to contribute in anyway possible! Just remember to format your code using Dart's built-in formatter. You can also support this project by contributing to [PokéAPI](https://github.com/PokeAPI/pokeapi).

## Credits:
  - [PokéAPI](https://github.com/PokeAPI/pokeapi).
  - [Project Pokémon](https://projectpokemon.org/) for documentation on save data.
  - [PKHeX](https://github.com/kwsch/PKHeX) for the structure and pointers of every save file.

### Rules of Contribution:
To make sure the code is consistent, I made some guidelines that I would like everyone to follow:

1. Follow this format for every class header:
   
   ```dart
   /// # `Class` Pokemon
   /// ## A class that represents a Pokémon from a Game.
   /// Extends the Species class.
      
   /// ### Variables:
   /// // write the variables here.
   /// ### Functions:
   /// // write the functions here.
   ```

   And follow this for every function header:

   ```dart
   /// # fetchSpecies(`int id`)
   /// ## Fetches a species from PokeAPI.
   /// // add some example code or explain what it does.
2. Always use hexadecimal instead of integers for file offsets.

   ✅ 0x01

   ❌ 1

3. Have fun!

## Copyrights:
Pokémon, its character names, related images, and other content referenced in this material are the property of their respective owners including but not limited to Nintendo, Creatures Inc., and Game Freak. All rights to the Pokémon franchise, including any related names, logos, or images, are reserved by their respective copyright holders. This material is intended for educational and informational purposes only and is not intended to infringe on any copyrights or trademarks. Pokémon and all related media are trademarks and copyright of their respective owners.
