dades_lp = load('lp_2_3.txt');
coef_2_lp = dades_lp(:,1);
coef_3_lp = dades_lp(:,2);
sz=5;

subplot(3,1,1);
scatter(coef_2_lp, coef_3_lp, sz, 'filled', 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',0.5);
title('Parametrización LP')
xlabel('Coeficiente 2')
ylabel('Coeficiente 3')
grid on
%%

dades_mfcc = load('mfcc_2_3.txt');
coef_2_mfcc = dades_mfcc(:,1);
coef_3_mfcc = dades_mfcc(:,2);
sz=5;

subplot(3,1,2);
scatter(coef_2_mfcc, coef_3_mfcc, sz, 'filled', 'MarkerEdgeColor',[.5 .2 0],'MarkerFaceColor',[.7 .2 0],'LineWidth',0.5);
title('Parametrización MFCC')
xlabel('Coeficiente 2')
ylabel('Coeficiente 3')
grid on

%%

dades_lpcc = load('lpcc_2_3.txt');
coef_2_lpcc = dades_lpcc(:,1);
coef_3_lpcc = dades_lpcc(:,2);
sz=5;

subplot(3,1,3);
scatter(coef_2_lpcc, coef_3_lpcc, sz, 'filled','MarkerEdgeColor',[.3 0 .5],'MarkerFaceColor',[.3 0 .7],'LineWidth',0.5);
title('Parametrización LPCC')
xlabel('Coeficiente 2')
ylabel('Coeficiente 3')
grid on

%MFCC

