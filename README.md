# Socio scripts

This repository contains various scripts for automating driver installations, application setups, and other system configurations in UncomOS.

> **Warning**: Most scripts require `sudo`. Always audit scripts first!

## Available Scripts 

#### Driver SHARP MX266N

Install PCL 6 printer driver for Linux (Ubuntu, Debian), version 1.18

```
bash -c "$(curl -L https://github.com/BarfleurLight/socio-scripts/raw/main/driver-sharp-mx266n/install.sh)" @ install
```

#### Activate and create icons for SPSS 27

Activation and installation of icons for SPSS 27. Start after install program.

```
bash -c "$(curl -LsS https://github.com/BarfleurLight/socio-scripts/raw/main/icons-spss27/install.sh)" @ install
```

#### Driver KYOSERA MA5500ifx

Install printer driver for Linux

```
bash -c "$(curl -L https://github.com/BarfleurLight/socio-scripts/raw/main/driver-kyosera-ma5500ifx/install.sh)" @ install
```

