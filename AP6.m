%[text] # Arbeitspaket 6: Modellierung eines Batteriespeichers
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

% AP4: Einspeiseleistung EE-Anlagen
Pmax_On = [17 14 13 11 13 17 28 41 48 45 42 43];
Pmax_Of = [371 377 377 372 350 321 304 321 323 319 328 343];
Pmax_PV = [0 0 0 44 118 158 151 97 56 0 0 0];

% AP5: Import-Export-Markt
c_export = 10;
c_import = 60;

% AP6: Batteriespeicher
batterieData = [
% 1     2   3     4       5       6       7   8       9
% Nr    SvO Pmin  Pmax    P_t<0   P_t>0   SnO Pc_max  Pd_max
  1     1   0     100     50      50      1   50      50
];
nBB = 1; % Anzahl Batteriespeicher
%%
%[text] ## Initialisierung
ap6 = optimproblem("Description", "AP6", "ObjectiveSense", "min");
%%
%[text] ## Entscheidungsvariablen
p = optimvar('p', nT, nPP, 'Type', 'integer', 'LowerBound', 0);
v = optimvar('v', nT, nPP, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
s_on = optimvar('s_on', nT, nPP, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
s_off = optimvar('s_off', nT, nPP, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
p_import = optimvar('p_import', nT, 'Type', 'integer', 'LowerBound', 0);
p_export = optimvar('p_export', nT, 'Type', 'integer', 'LowerBound', 0);
p_ab  = optimvar('p_ab',  nT, nBB, 'Type', 'integer', 'LowerBound', 0);
p_auf = optimvar('p_auf', nT, nBB, 'Type', 'integer', 'LowerBound', 0);
%%
%[text] ## Hilfsvariablen
% Kostenvariablen
c_var_vector = kwData(:, 5)';
c_var_matrix = repmat(c_var_vector, nT, 1);

c_fix_vector = kwData(:, 6)';
c_fix_matrix = repmat(c_fix_vector, nT, 1);

c_anf_vector = kwData(:, 7)';
c_anf_matrix = repmat(c_anf_vector, nT, 1);

% Leistungsgrenzen
p_max_vector = kwData(:, 4)';
p_max_matrix = repmat(p_max_vector, nT, 1);

p_max_matrix(:, 3) = Pmax_On';
p_max_matrix(:, 4) = Pmax_Of';
p_max_matrix(:, 5) = Pmax_PV';

p_min_vector = kwData(:, 3)';
p_min_matrix = repmat(p_min_vector, nT, 1);

p_max_matrix(p_max_matrix < p_min_matrix) = 0;
p_min_matrix(p_max_matrix == 0) = 0;

% Rampenbeschränkungen
ru_vector = kwData(:, 8)';
ru_vector(ru_vector == 0) = p_max_vector(ru_vector == 0);
ru_matrix = repmat(ru_vector, nT, 1);

rd_vector = kwData(:, 8)';
rd_vector(rd_vector == 0) = p_max_vector(rd_vector == 0);
rd_matrix = repmat(rd_vector, nT, 1);

su_vector = kwData(:, 9)';
su_vector(su_vector == 0) = p_max_vector(su_vector == 0);
su_matrix = repmat(su_vector, nT, 1);

sd_vector = kwData(:, 9)';
sd_vector(sd_vector == 0) = p_max_vector(sd_vector == 0);
sd_matrix = repmat(sd_vector, nT, 1);

% Start- und Endwerte
v_start_vector = kwData(:, 2)';
v_prev_matrix = [v_start_vector; v(1:nT-1, :)];

v_end_vector = kwData(:, 11)';
v_next_matrix = [v(2:nT, :); v_end_vector];

p_start_vector = kwData(:, 10)';
p_prev_matrix = [p_start_vector; p(1:nT-1, :)];

% Speichereigenschaften
p_batt_max_vector = batterieData(:, 4)';
p_batt_max_matrix = repmat(p_batt_max_vector, nT, 1);

p_batt_start_vector = batterieData(:, 5)';
p_batt_end_vector = batterieData(:, 6)';

p_ab_max_vector = batterieData(:, 8)';
p_ab_max_matrix = repmat(p_ab_max_vector, nT, 1);

p_auf_max_vector = batterieData(:, 9)';
p_auf_max_matrix = repmat(p_auf_max_vector, nT, 1);
%%
%[text] ## Zielfunktion
% erweiterte Zielfunktion (7.1)
ap6.Objective = sum(sum(c_var_matrix .* p + c_fix_matrix .* v + c_anf_matrix .* s_on)) + sum(c_import .* p_import - c_export .* p_export);
%%
%[text] ## Lineare Nebenbedingungen
% Deckung der Nachfrage (8.3)
ap6.Constraints.demand = sum(p, 2) - p_export + p_import + p_ab - p_auf == demand()';

% Leistungsgrenzen (4.2)
ap6.Constraints.min = p_min_matrix .* v <= p;
ap6.Constraints.max = p <= p_max_matrix .* v;
ap6.Constraints.aufladen = p_auf <= p_auf_max_matrix;
ap6.Constraints.abgeben = p_ab <= p_ab_max_matrix;

% Anfahrtskosten (5.1)
ap6.Constraints.anfahrt = v - v_prev_matrix == s_on - s_off;

% Exklusivität (5.2)
ap6.Constraints.exklusiv = s_on + s_off <= 1;

% Ramp-Up (5.4)
ap6.Constraints.ramp_up = p_max_matrix >= p - p_prev_matrix - (su_matrix - p_max_matrix) .* v - (ru_matrix - su_matrix) .* v_prev_matrix;

% Ramp-Down (5.5)
ap6.Constraints.ramp_down = 0 <= p_max_matrix + p - p_prev_matrix + (rd_matrix - sd_matrix) .* v + (sd_matrix - p_max_matrix) .* v_prev_matrix;

% Shutdown (5.6)
ap6.Constraints.shutdown = p <= sd_matrix .* v + (p_max_matrix - sd_matrix) .* v_next_matrix;

% Energiebilanz Batterie (8.1)
ap6.Constraints.bilanz = sum(p_auf, 1) - sum(p_ab, 1) == 0;

% Kapazität (8.2)
ap6.Constraints.kapazitaet_min = 0 <= p_batt_start_vector + cumsum(p_auf - p_ab, 1)
ap6.Constraints.kapazitaet_max = p_batt_start_vector + cumsum(p_auf - p_ab, 1) <= p_batt_max_matrix;

%%
%[text] ## Lösung
solAP6 = solve(ap6);
%%
%[text] ## Ausgabe
disp('Optimale Kraftwerksleistungen:');
disp(solAP6.p);
disp(solAP6.p_import - solAP6.p_export);
disp(solAP6.p_auf - solAP6.p_ab);

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":9.4}
%---
