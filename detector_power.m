function Plank()

% physical constants
h = 6.626*10^-34;
c = 2.998*10^8;
kb = 1.38*10^-23;

% plotting parameters
P_list = [];
T_list = [4000:2000:8000];
wavelengths = [0.1:0.1:2.5]*10^-6;
wave_list = [];
for i = 1:length(T_list)
    wave_list = [wave_list wavelengths];
end

% experimental parameters
del_lambda = 5*10^-9; % FWHM of spectral filter in nm
A_detector = 5*10^-6; % detector area in m^2
r = 0.3; % distance of 1 ft from detector to target in m
A_target = pi*(0.01/2)^2; % area of 10 mm diameter laser spot size in m^2
Omega = A_detector/r^2; % solid angle in sr

n = 0; % temp count
m = 0; % wavelength count
while n < length(T_list)
    while m < length(wavelengths)
        lambda1 = wavelengths(m+1) - del_lambda/2;
        lambda2 = wavelengths(m+1) + del_lambda/2;
        % spectral radiance in W/(m^3*sr)
        B = @(wavelength) (2.*h.*c^2./wavelength.^5)./(exp((h.*c)./(wavelength.*kb.*T_list(n+1)))-1);
        % integrated spectral radiance in  W/m^2*sr
        B_int = integral(B,lambda1,lambda2);
        P = B_int*Omega*A_target; % Power at T and wavelength in W
        P_list = [P_list P];
        m = m + 1;
    end
    m = 0;
    n = n + 1;
end

plot(wave_list,P_list)
title('Power as a Function of Wavelength')
xlabel('Wavelength (m)')
ylabel('Power (Watts)')

end
