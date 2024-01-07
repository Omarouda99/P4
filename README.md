PAV - P4: reconocimiento y verificación del locutor
===================================================

Obtenga su copia del repositorio de la práctica accediendo a [Práctica 4](https://github.com/albino-pav/P4)
y pulsando sobre el botón `Fork` situado en la esquina superior derecha. A continuación, siga las
instrucciones de la [Práctica 2](https://github.com/albino-pav/P2) para crear una rama con el apellido de
los integrantes del grupo de prácticas, dar de alta al resto de integrantes como colaboradores del proyecto
y crear la copias locales del repositorio.

También debe descomprimir, en el directorio `PAV/P4`, el fichero [db_8mu.tgz](https://atenea.upc.edu/mod/resource/view.php?id=3654387?forcedownload=1)
con la base de datos oral que se utilizará en la parte experimental de la práctica.

Como entrega deberá realizar un *pull request* con el contenido de su copia del repositorio. Recuerde
que los ficheros entregados deberán estar en condiciones de ser ejecutados con sólo ejecutar:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.sh
  make release
  run_spkid mfcc train test classerr verify verifyerr
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Recuerde que, además de los trabajos indicados en esta parte básica, también deberá realizar un proyecto
de ampliación, del cual deberá subir una memoria explicativa a Atenea y los ficheros correspondientes al
repositorio de la práctica.

A modo de memoria de la parte básica, complete, en este mismo documento y usando el formato *markdown*, los
ejercicios indicados.

## Ejercicios.

### SPTK, Sox y los scripts de extracción de características.

- Analice el script `wav2lp.sh` y explique la misión de los distintos comandos involucrados en el *pipeline*
  principal (`sox`, `$X2X`, `$FRAME`, `$WINDOW` y `$LPC`). Explique el significado de cada una de las 
  opciones empleadas y de sus valores.
   >En un principio, requerimos una entrada de señal en formato wav, y se nos genera un archivo denominado output.lp.
   >También observamos que deberemos introducir 3 parmetros en un orden determinado. Primero el coeficiente de predicción lineal, después el fichero de entrada y finalmente el fichero de salida
   
   * SoX sirve para realizar tareas con ficheros de audio como pasar de un formato de señal o fichero a otro, realizar transformadas, reducción de ruido y otras operaciones de procesado de audio, reducción de ruido.
   * x2x converts data from standard input to a different data type, sending the result to standard output. The input and output data type are specified by command line options as described below.

   * frame converts a sequence of input data from infile (or standard input) to a series of
possibly-overlapping frames with period P and length L, and sends the result to standard
output.

   * window multiplies, on an element-by-element basis, length L input vectors from infile (or
standard input) by a specified windowing function, sending the result to standard output.

   * lpc calculates linear prediction coefficients (LPC) from L-length framed windowed data
from infile (or standard input), sending the result to standard output.

- Explique el procedimiento seguido para obtener un fichero de formato *fmatrix* a partir de los ficheros de
  salida de SPTK (líneas 45 a 51 del script `wav2lp.sh`).
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.sh
  # Our array files need a header with the number of cols and rows:
  ncol=$((lpc_order+1)) # lpc p =>  (gain a1 a2 ... ap) 
  nrow=`$X2X +fa < $base.lp | wc -l | perl -ne 'print $_/'$ncol', "\n";'`
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  * ¿Por qué es más conveniente el formato *fmatrix* que el SPTK?
    >fmatrix permite un mejor orden de los datos

- Escriba el *pipeline* principal usado para calcular los coeficientes cepstrales de predicción lineal
  (LPCC) en su fichero <code>scripts/wav2lpcc.sh</code>:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.sh
  # Main command for feature extration
  sox $inputfile -t raw -e signed -b 16 - | $X2X +sf | $FRAME -l 240 -p 80 | $WINDOW -l 240 -L 240 |
	$LPC -l 240 -m $lpc_order | $LPCC -m $lpc_order -M $lpcc_order > $base.lpcc || exit 1
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Escriba el *pipeline* principal usado para calcular los coeficientes cepstrales en escala Mel (MFCC) en su
  fichero <code>scripts/wav2mfcc.sh</code>:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.sh
  # Main command for feature extration
  sox $inputfile -t raw -e signed -b 16 - | $X2X +sf | $FRAME -l 240 -p 80 | $WINDOW -l 240 -L 240 |
	  $MFCC -l 240 -s 8 -m $mfcc_order -n $mfcc_nfilter > $base.mfcc || exit 1
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Extracción de características.

- Inserte una imagen mostrando la dependencia entre los coeficientes 2 y 3 de las tres parametrizaciones
  para todas las señales de un locutor.

  + Indique **todas** las órdenes necesarias para obtener las gráficas a partir de las señales 
    parametrizadas.
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.sh
    FEAT=lp run_spkid lp
    FEAT=lpcc run_spkid lpcc
    FEAT=mfcc run_spkid mfcc
    fmatrix_show work/lp/BLOCK01/SES017/*.lp | egrep '^\[' | cut -f4,5 > lp_2_3.txt
    fmatrix_show work/lpcc/BLOCK01/SES017/*.lpcc | egrep '^\[' | cut -f4,5 > lpcc_2_3.txt 
    fmatrix_show work/mfcc/BLOCK01/SES017/*.mfcc | egrep '^\[' | cut -f4,5 > mfcc_2_3.txt
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    > Además usaremos el codigo de matlab parametrizacion.m para observar las graficas
    > ![param_lp](https://github.com/Omarouda99/P4/assets/99822243/ae4610c2-8a11-44a0-8039-ea11bac4a0bc)
    > ![param_lpcc](https://github.com/Omarouda99/P4/assets/99822243/22780f58-9d55-47a9-b1e8-b41e07b63a24)
    > ![param_mfcc](https://github.com/Omarouda99/P4/assets/99822243/83d0251a-cc79-427a-a32b-1e5a8269aed9)


  + ¿Cuál de ellas le parece que contiene más información?
    >LPCC y MFCC tienen los coeficientes más incorrelados, por lo tanto tendremos más información. De hecho, el caso de MFCC parece incluso más disperso. Sin embargo podemos ver que la parametrización LP tiene correlación (sus puntos están más o menos ordenados), eso nos indica que no tenemos mucha información.
    
- Usando el programa <code>pearson</code>, obtenga los coeficientes de correlación normalizada entre los
  parámetros 2 y 3 para un locutor, y rellene la tabla siguiente con los valores obtenidos.

  |                        | LP   | LPCC | MFCC |
  |------------------------|:----:|:----:|:----:|
  | &rho;<sub>x</sub>[2,3] |-0.873524|0.150782|-0.139062|
  
  + Compare los resultados de <code>pearson</code> con los obtenidos gráficamente.
    >Cuanto más cercano a 1 es el valor absoluto de la rho, más correlado será la parametrización. En este caso, el valor más cercano a 1 es el de LP, tal y como hemos visto en las graficas, y tambiñen MFCC es el más alejado, como hemos comprovado tambien en las graficas.
  
- Según la teoría, ¿qué parámetros considera adecuados para el cálculo de los coeficientes LPCC y MFCC?
  > La teoría dice que para el cálculo de LPCC debería ser suficiente con 13 coeficientes, mientras que para MFCC se suelen escoger 13 coeficientes y entre 24 y 40 filtros.
  
### Entrenamiento y visualización de los GMM.

Complete el código necesario para entrenar modelos GMM.

- Inserte una gráfica que muestre la función de densidad de probabilidad modelada por el GMM de un locutor
  para sus dos primeros coeficientes de MFCC.
  >![regioncovarage_mfcc](https://github.com/Omarouda99/P4/assets/99822243/72623474-4d1d-4b5e-8a63-e002ef2698bc)

- Inserte una gráfica que permita comparar los modelos y poblaciones de dos locutores distintos (la gŕafica
  de la página 20 del enunciado puede servirle de referencia del resultado deseado). Analice la capacidad
  del modelado GMM para diferenciar las señales de uno y otro.
  >![poblacion1_mfcc](https://github.com/Omarouda99/P4/assets/99822243/34a80ec8-66ea-4302-b0f7-b22ab5e03ea3)
  >![poblacion2_mfcc](https://github.com/Omarouda99/P4/assets/99822243/c4f1efd3-133d-452d-bfc1-d5cfe75005ad)
  >
  >El locutor de la primera grafica está mejor modelado que la segunda debido a que el modelo GMM corresponde al primer locutor


### Reconocimiento del locutor.

Complete el código necesario para realizar reconociminto del locutor y optimice sus parámetros.

- Inserte una tabla con la tasa de error obtenida en el reconocimiento de los locutores de la base de datos
  SPEECON usando su mejor sistema de reconocimiento para los parámetros LP, LPCC y MFCC.
  
  ![tassa_error](https://github.com/Omarouda99/P4/assets/99822243/c4468c66-ea7b-4daf-8a7e-9d763cd21de3)
  |                        | LP   | LPCC | MFCC |
  |------------------------|:----:|:----:|:----:|
  | error rate |9.17%|0.64%|0.76%|

### Verificación del locutor.

Complete el código necesario para realizar verificación del locutor y optimice sus parámetros.

- Inserte una tabla con el *score* obtenido con su mejor sistema de verificación del locutor en la tarea
  de verificación de SPEECON. La tabla debe incluir el umbral óptimo, el número de falsas alarmas y de
  pérdidas, y el score obtenido usando la parametrización que mejor resultado le hubiera dado en la tarea
  de reconocimiento.
  
  > LP:
  
  ![image](https://github.com/Omarouda99/P4/assets/99822243/33fe2a87-e90b-4892-8914-a51b2da1760d)

  > LPCC:
  
  ![image](https://github.com/Omarouda99/P4/assets/99822243/de66a611-0697-4293-a606-2f5c6238617c)
  
  > MFCC:
  
  ![image](https://github.com/Omarouda99/P4/assets/99822243/491ab926-05ea-4e18-bf2e-724a3fa33e57)

  |                        | LP   | LPCC | MFCC |
  |------------------------|:----:|:----:|:----:|
  | threshold |0.129967328569992|-0.65094390278994|-0.0592828154588934|
  | missed |0.01|0.008|0.036|
  | false alarm |0.01|0.003|0.004|
  | cost detection |41.1|3.5|7.2|
 
### Test final

- Adjunte, en el repositorio de la práctica, los ficheros `class_test.log` y `verif_test.log` 
  correspondientes a la evaluación *ciega* final.

### Trabajo de ampliación.

- Recuerde enviar a Atenea un fichero en formato zip o tgz con la memoria (en formato PDF) con el trabajo 
  realizado como ampliación, así como los ficheros `class_ampl.log` y/o `verif_ampl.log`, obtenidos como 
  resultado del mismo.
