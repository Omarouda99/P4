dades_lp = load('lp_2_3.txt');
coef_2_lp = dades_lp(:,1);
coef_3_lp = dades_lp(:,2);
sz=5;

figure;
scatter(coef_2_lp, coef_3_lp, sz);
title('Parametrización LP')
xlabel('Coeficiente 2')
ylabel('Coeficiente 3')
grid on
%%

dades_mfcc = load('mfcc_2_3.txt');
coef_2_mfcc = dades_mfcc(:,1);
coef_3_mfcc = dades_mfcc(:,2);
sz=5;

figure;
scatter(coef_2_mfcc, coef_3_mfcc, sz);
title('Parametrización MFCC')
xlabel('Coeficiente 2')
ylabel('Coeficiente 3')
grid on

%%

dades_lpcc = load('lpcc_2_3.txt');
coef_2_lpcc = dades_lpcc(:,1);
coef_3_lpcc = dades_lpcc(:,2);
sz=5;

figure;
scatter(coef_2_lpcc, coef_3_lpcc, sz);
title('Parametrización LPCC')
xlabel('Coeficiente 2')
ylabel('Coeficiente 3')
grid on
