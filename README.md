# SpectralBroadening
A small code to compute spectral broadening function

$$ \gamma(E) = \Gamma_\mathrm{H} + \frac{\Gamma_\mathrm{M}}{2} + \frac{\Gamma_\mathrm{M}}{\pi} \times \arctan \left \[ \frac{\pi}{3} \frac{\Gamma_\mathrm{M}}{A_\mathrm{W}} \left ( x - \frac{1}{x^2} \right ) \right ] $$ 

with 

$$ x = \frac{E-E_\mathrm{Fermi}}{A_\mathrm{c}} $$

which is Equation (15) from Phys. Rev. B 214104 (2018)

<b>Compilation</b>

Straighforwardly:

    gfortran -o SpectralBroadening SpectralBroadening.f90 

<b>Input</b>

An input file <code>input.dat</code> should be created with the following variables:
```
   &INPUT_BROADENING
      ggh = 
      ggm = 
      ac  = 
      aw  = 
      ef  = 
      emax =
      emin = 
      xnepoints = 
      filename = 
   /
```   
The variables <code>ggh</code> (greek G H), <code>ggm</code>, <code>ac</code>, <code>aw</code> and <code>ef</code> are parameters taken directly from the equation above and should be provided in eV. Due to the way <code>XSpectra</code> works <code>ef</code> can be set to 0.
  
Finally, <code>emin</code>, <code>emax</code> and <code>xnepoints</code> denote the minimum and maximum energy range, and well as the number of energy points to consider. <code>Filename</code> is the name of the file where the energy dependent broadening will be written to disc.

<b>Execution</b>

Once compiled the code can be executed simply, and will provide the specific plot related XSpectra input paramaters

```
./SpectralBroadening

To use the broadening generated here with XSpectra, you must set:

&plot
   gamma_mode = "file"
   gamma_file = "broadening.dat
   xnepoints =   500
   xemin = -10.00
   xemax =  30.00
   terminator=.true.
   cut_occ_states=.true.
/

```

<b>Output</b>

The output is an ascii file containing two columns of data, the enery and the broadening. Note that below the Fermi level the broadening is set to zero.
