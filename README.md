# Wave-Digital-Filter-Modeling

Wave digital filter (WDF) implementation of a piezoelectric MEMS loudspeaker,
starting from a linear lumped-element model (electrical, mechanical and acoustic
domains, all converted to the mechanical domain). The WDF output is compared with
a Simscape reference simulation. Assignment 2 for the SSSP course
(Politecnico di Milano, 2025).

Authors: Martina Luyten and Andrea Casati

## Method

- The circuit has 10 linear WD elements, 7 three-port adaptors (4 series, 3 parallel),
  1 four-port series adaptor and the source Fin(t).
- Port impedances follow the adaptation (reflection-free) conditions.
- Each sample is processed with a forward scan, local root scattering and a backward scan.

## Result

On a 500 Hz - 20 kHz sweep at 192 kHz sampling, the WDF output matches the
Simscape reference with an MSE of 0.0119 Pa². See `Report.pdf` for details.

## How to run

1. Get the course files (not included): `mems_spk_SSC.slx`, `ssc_script.m`,
   `vin.mat`, `ssc_output.mat`. Put them in `MATLAB/`.
2. Open MATLAB in `MATLAB/` and run `mems_spk_WD.m`.

It plots the output pressure, the SPL frequency response and the error signal,
and prints the MSE. It needs the function `impzest` (provided with the course
material) and the Signal Processing Toolbox.

## Files

| File | Purpose |
|---|---|
| `MATLAB/mems_spk_WD.m` | WDF model, simulation and plots |
| `Report.pdf` | Report with method, results and discussion |
