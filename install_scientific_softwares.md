# Latex
## References

## TBD

# Matlab
## References 
1. [MATLAB for UCSD Students](https://matlab.ucsd.edu/student.html) - for licensing and SSO authorization

1. [Download and Install MATLAB](https://www.mathworks.com/help/install/ug/install-products-with-internet-connection.html)

## Installation type

Install matlab just for ONE non-`sudo` user

## Steps

1. Sign into __MathWorks__ with your email and [Download](https://www.mathworks.com/downloads/) the MATLAB installer of the matlab release you intend to install e.g. `R2024a`, `R2024b` etc. The `.zip` file installer will be under `~/Downloads`
1. `cd ~/Downloads # Get into the downloads folder`
1. `unzip matlab_R20*.zip -d ./matlab_R20XXy_Linux # Extract the zip file`
1. `xhost +SI:localuser:root`
1. `./install.sh # We are not doing sudo -H ./install as the user is not sudo`
    - __Create the folder__ `~/MATLAB/R20XXy/` and give it as the __installation directory__ when prompted by the installer
1. `xhost -SI:localuser:root`
1. Login as super user to create a `.desktop` file in `/usr/share/applications/` by executing the command below after changing `R20XXy` to say `R2024a`, `R2024b` etc.
1. `su <super-user>`
1. Create a desktop entry for MatLab  
```
echo '[Desktop Entry]
Version = R20XXy
Type = Application
Terminal = false
Name = MATLAB-R20XXy 
Exec = ~/MATLAB/R20XXy/bin/matlab -desktop
Icon = ~/MATLAB/logo.png
Categories = Development;Math;Science;Education;' | sudo tee /usr/share/applications/MATLAB-R20XXy.desktop # Create a desktop entry for MatLab
```




