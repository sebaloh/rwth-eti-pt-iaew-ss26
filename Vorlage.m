%% Eingangsdaten
% Optimierungszeitraum
nT = 12; % Anzahl Stunden

% Kraftwerke
kwData = [
% 1     2   3     4       5       6       7      8       9       10      11
% Nr    SvO Pmin  Pmax    c_var   c_fix   c_anf  RU_RD   SU_SD   P_t<0   SnO
  1     1   110   450     12.00   2000    36000  160     110     450     1    % KOHLEKRAFTWERK
  2     1   70    270     42.00   700     11000  160     70      270     1    % GASKRAFTWERK
  3     0   20    90      7.00    350     0      0       20      0       1    % WINDENERGIEANLAGE ONSHORE
  4     0   110   420     8.00    1900    0      0       110     0       1    % WINDENERGIEANLAGE OFFSHORE
  5     0   0     160     0.00    250     0      0       0       0       1    % PHOTOVOLTAIKANLAGE
  6     1   50    120     5.00    1200    0      0       50      120     1    % LAUFWASSERKRAFTWERK
];
nPP = 6; % Anzahl Kraftwerke

% Nachfrage
demand = [825 720 680 850 1060 1275 1300 1150 1230 1100 850 680];

% AP4: Einspeiseleistung EE-Anlagen
Pmax_On = [17 14 13 11 13 17 28 41 48 45 42 43];
Pmax_Of = [371 377 377 372 350 321 304 321 323 319 328 343];
Pmax_PV = [0 0 0 44 118 158 151 97 56 0 0 0];

% AP5: Import-Export-Markt
c_export = 4.5;
c_import = 15;

% AP6: Batteriespeicher
batterieData = [
% 1     2   3     4       5       6       7   8       9
% Nr    SvO Pmin  Pmax    P_t<0   P_t>0   SnO Pc_max  Pd_max
  1     1   0     100     50      50      1   50      50
];
nBB = 1; % Anzahl Batteriespeicher

%% Hilfsvariablen

LB_vector = zeros(nPP, 1); % Nullvektor mit Dimension (Kraftwerke x 1)
% ...

% Kostenvariablen
c_var_vector = [kwData(:, 5)];
c_var_matrix = repmat(c_var_vector, 1, nT);
% ...
% c_fix_vector, c_fix_matrix
% c_anf_vector, c_anf_matrix

% Kraftwerksparameter
p_max_vector = [kwData(:, 4)];
p_max_matrix = repmat(p_max_vector, 1, nT);
% ...
% p_min_vector, ...
