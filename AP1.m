%[text] # Arbeitspaket 1: Merit Order
%%
%[text] ## Eingangsdaten
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
%%
%[text] ## Hilfsvariablen
% Kostenvariablen
c_var_vector = kwData(:, 5)';
c_var_matrix = repmat(c_var_vector, nT, 1);

% Kraftwerksparameter
p_max_vector = kwData(:, 4)';
p_max_matrix = repmat(p_max_vector, nT, 1);
%%
%[text] ## Initialisierung
ap1 = optimproblem("Description", "AP1", "ObjectiveSense", "min");
%%
%[text] ## Entscheidungsvariablen
% Leistungsgrenzen (3.2)
p = optimvar('p', nT, nPP, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', p_max_matrix);
%%
%[text] ## Zielfunktion
% Zielfunktion (3.3)
ap1.Objective = sum(sum(c_var_matrix .* p));
%%
%[text] ## Lineare Nebenbedingungen
% Deckung der Nachfrage (3.1)
ap1.Constraints.demand = sum(p, 2) == demand()';
%%
%[text] ## Lösung
solAP1 = solve(ap1);
%%
%[text] ## Ausgabe
disp('Optimale Kraftwerksleistungen:')
disp(solAP1.p)

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":9.4}
%---
