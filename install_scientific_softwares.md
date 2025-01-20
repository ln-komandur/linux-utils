# Latex
## References
[How to install LaTex on Ubuntu 22.04](https://linuxconfig.org/how-to-install-latex-on-ubuntu-22-04-jammy-jellyfish-linux)

## Installation type

Install latex for all users one the system by logging in as `su <super-user>`

## Steps

1. `su <super-user> # Login as super user`
1. `python3 --version # Find python3 version` . The output may be similar to the below
    ```
    Python 3.10.12
    ```
1. `sudo pip show httpx # Find the version of httpx on pip` . Versions immediately after 0.27.2 give problems for `nala` as of January 2025 similar to the below and as described as [faced by other applications, and also with the solution to downgrade httpx to 0.27.2](https://community.openai.com/t/error-with-openai-1-56-0-client-init-got-an-unexpected-keyword-argument-proxies/1040332/4)
    ```
    Traceback (most recent call last):
      File "/usr/bin/nala", line 8, in <module>
        sys.exit(main())
      File "/usr/lib/python3/dist-packages/nala/__main__.py", line 41, in main
        nala()
    ```
1. `sudo pip install httpx==0.27.2 # Downgrade the version of httpx to 0.27.2 if after that as of January 2025`
1. `sudo pip show httpx # Verify that the version of httpx on pip os 0.27.2`
1. `sudo nala install texlive-latex-extra # Install texlive-latex-extra`
1. `sudo nala install texstudio # Install latex.` This should also give the desktop launcher with an icon for all users

# Matlab
## References 
1. [MATLAB for UCSD Students](https://matlab.ucsd.edu/student.html) - for licensing and SSO authorization

1. [Download and Install MATLAB](https://www.mathworks.com/help/install/ug/install-products-with-internet-connection.html)

1. [How do I make a desktop launcher for MATLAB in Ubuntu](https://www.mathworks.com/matlabcentral/answers/20-how-do-i-make-a-desktop-launcher-for-matlab-in-linux)

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
Exec = /home/<users-home>/MATLAB/R20XXy/bin/matlab -desktop
Icon = /home/<users-home>/MATLAB/R20XXy/ui/install/product_installer_ui/images/membrane-logo.png
Categories = Development;Math;Science;Education;' | sudo tee /usr/share/applications/MATLAB-R20XXy.desktop # Create a desktop entry for MatLab
```
