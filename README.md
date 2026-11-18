# Wave-Digital-Filter-Modeling

Wave digital filter (WDF) implementation of a piezoelectric MEMS loudspeaker,
starting from a linear lumped-element model (electrical, mechanical and acoustic
domains, all converted to the mechanical domain). The WDF output is compared with
a Simscape reference simulation.

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

Open MATLAB in `MATLAB/` and run `mems_spk_WD.m`. It plots the output pressure,
the SPL frequency response and the error signal, and prints the MSE.

Requires MATLAB with the Signal Processing Toolbox. The Simscape model
(`mems_spk_SSC.slx`) is optional and only needed to regenerate the reference output.

## Files

| File | Purpose |
|---|---|
| `MATLAB/mems_spk_WD.m` | WDF model, simulation and plots (our implementation) |
| `MATLAB/mems_spk_SSC.slx` | Simscape reference model (course material) |
| `MATLAB/ssc_script.m` | Script that defines the Simscape input signal (course material) |
| `MATLAB/vin.mat` | Input sweep signal (course material) |
| `MATLAB/ssc_output.mat` | Simscape ground-truth output (course material) |
| `Report.pdf` | Report with method, results and discussion |

## Acknowledgements

Developed for the course Sound Analysis, Synthesis and Processing (SSSP) at
Politecnico di Milano, taught by Prof. Augusto Sarti. The assignment, the Simscape
model, `ssc_script.m`, `vin.mat` and `ssc_output.mat` were provided by the course;
the WDF implementation in `mems_spk_WD.m` and the report are our own work.
