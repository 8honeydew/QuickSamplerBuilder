# Quick Sampler Builder

A Lua ReaScript that automatically builds a playable **ReaSamplOmatic5000 (RS5K)** multisampler from a folder of note samples.

## Features

* Loads all `.wav` files in a sample folder
* Maps filenames (e.g. `C1.wav`, `C#1.wav`) to MIDI notes
* Previews detected mappings before building
* Creates or updates a single **Quick Sampler Instrument** track

## Usage

1. In REAPER, open **Actions → Show Action List... → ReaScript → Load...** and select `QuickSampler.lua`. 
2. Run the script.
3. Select **any WAV file** inside the sample folder you want to use.
4. Confirm the preview, and the instrument will be built automatically.

A small set of test samples (`C1`–`C2`) is included for trying the script.

## Current Limitations

* Filenames must follow the format `C4.wav` or `C#4.wav`
* Currently supports sharp (`#`) note names only
* Assumes one sample per MIDI note
