/*----------------------------------------------*/
/*----------------------------------------------*/
/* 1/ Import de la base d'apprentissage et test */
/*----------------------------------------------*/
/*----------------------------------------------*/


DATA BASE_ETUDE;
	SET DROGUE;
RUN;
/*1685 observations*/

/*------------------------------------------*/
/*------------------------------------------*/
/* 2/ Audit des données / analyse univariée */
/*------------------------------------------*/
/*------------------------------------------*/
/* Cette étape permet de valider la qualité des données */
/* et de s'approprier les données avant l'analyse       */

PROC CONTENTS DATA = BASE_ETUDE;
RUN;


/*--------------------------------------------*/
/* Analyse univariée : variables qualitatives */
/*--------------------------------------------*/
PROC FREQ DATA = BASE_ETUDE;
	TABLES An
		   Lieu
		   Drogue/ MISSING;
RUN;

/* Doit-on rassembler les 3 heroines et les 3 marijuana */
/* On remarque la présence d'héroine inconnue : à identifier ? */
/* An: Regrouper certaines modalités (rééquilibrer les effectifs) */
/* Pas de données manquantes*/


/*---------------------------------------------*/
/* Analyse univariée : variables quantitatives */
/*---------------------------------------------*/

PROC MEANS DATA = BASE_ETUDE N NMISS MIN Q1 MEDIAN MEAN Q3 MAX;
	VAR Prix
        Poids
        Purete;
RUN;

/* Prix:   Moyenne et médiane sont très différentes.*/
/* Ceci est dû à des valeurs extrêmes (à identifier)*/
/* Poids:   Moyenne et médiane sont très différentes.*/
/* Ceci est dû à des valeurs extrêmes (à identifier)*/
/* Purete: Rien à signaler */




/*----------------------------*/
/* Représentations graphiques */
/*----------------------------*/

TITLE 'Distribution de la purete de la drogue';
PROC SGPLOT DATA = BASE_ETUDE;
	HISTOGRAM Purete;
	DENSITY Purete / TYPE = NORMAL LEGENDLABEL = 'NORMAL' LINEATTRS = (PATTERN = SOLID);
	DENSITY Purete / TYPE = KERNEL LEGENDLABEL = 'KERNEL' LINEATTRS = (PATTERN = SOLID);
	KEYLEGEND / LOCATION = INSIDE POSITION = TOPRIGHT ACROSS = 1;
  	XAXIS DISPLAY = (NOLABEL);
RUN;
/* Le Hashish a toujours 100% de pureté, donc on ne peut pas comparer son prix en fonction de sa pureté. */

TITLE 'Distribution du prix de la drogue';
PROC SGPLOT DATA = BASE_ETUDE;
	HISTOGRAM Prix;
	DENSITY Prix / TYPE = NORMAL LEGENDLABEL = 'NORMAL' LINEATTRS = (PATTERN = SOLID);
	DENSITY Prix / TYPE = KERNEL LEGENDLABEL = 'KERNEL' LINEATTRS = (PATTERN = SOLID);
	KEYLEGEND / LOCATION = INSIDE POSITION = TOPRIGHT ACROSS = 1;
  	XAXIS DISPLAY = (NOLABEL);
RUN;

/* N'a pas de sens */

TITLE 'Distribution du poids de la drogue';
PROC SGPLOT DATA = BASE_ETUDE;
	HISTOGRAM Poids;
	DENSITY Poids / TYPE = NORMAL LEGENDLABEL = 'NORMAL' LINEATTRS = (PATTERN = SOLID);
	DENSITY Poids / TYPE = KERNEL LEGENDLABEL = 'KERNEL' LINEATTRS = (PATTERN = SOLID);
	KEYLEGEND / LOCATION = INSIDE POSITION = TOPRIGHT ACROSS = 1;
  	XAXIS DISPLAY = (NOLABEL);
RUN;
/* Alternance de pics et creux : Variable à découper en 3 classes: 0-330, 330-860, 860- */
/* On observe un point aberrant en 9072 que l'on peut choisir de supprimer. */


TITLE 'Vente de drogues en fonction des années';
PROC SGPLOT DATA = DROGUE;
	VBOX Prix / CATEGORY = An;
	YAXIS GRID;
RUN;

TITLE 'Vente de drogues en fonction des poids';
PROC SGPLOT DATA = DROGUE;
	VBOX Prix / CATEGORY = Poids;
	YAXIS GRID;
RUN;


/*-------------------------*/
/*-------------------------*/
/* 3/ Features engineering */
/*-------------------------*/
/*-------------------------*/


/*----------------*/
/* Discrétisation */
/*----------------*/


/*Discrétisation du poids de la drogue */

DATA BASE_ETUDE;
	SET BASE_ETUDE;

LENGTH Poids_REC $15.;

IF     Poids <= 330  THEN Poids_REC = 'Low';
ELSE IF Poids <= 860 THEN Poids_REC = 'Medium';
					 ELSE Poids_REC = 'High';
RUN;


/* Vérification */
PROC FREQ DATA = BASE_ETUDE;
	TABLES Poids_REC / MISSING;
RUN;








/*----------------------------------------------------------*/
/*----------------------------------------------------------*/
/* 4/ Analyse bi-variée : Croisements cible - prédicteurs */
/*----------------------------------------------------------*/
/*----------------------------------------------------------*/

/*-------------------------*/
/* Variables quantitatives */
/*-------------------------*/



/*-------------------------*/
/* Variables qualitatives */
/*-------------------------*/

/* On pourrait supprimer la valeur en 9000, plus herO, ou tenter d'identifier herO par rapport aux autres heroines*/
/* dire que le prix du hashish est seulement en fonction du poids et peut-être en fonction du lieu */




/* On étudie d'abord les lieux pour la cocaine */

DATA Coc;
	SET BASE_ETUDE (WHERE= (DROGUE = 'Coc'));
RUN;
TITLE 'Prix de la cocaine en fonction des lieux';
PROC SGPLOT DATA = Coc;
	VBOX Prix / CATEGORY = Lieu;
	YAXIS GRID;
RUN;

TITLE 'Prix de la cocaine en fonction des années';
PROC SGPLOT DATA = Coc;
	VBOX Prix / CATEGORY = An;
	YAXIS GRID;
RUN;


/*Etude des lieux pour le crack */
DATA Crack;
	SET BASE_ETUDE (WHERE= (DROGUE = 'Crack'));
RUN;
TITLE 'Prix du crack en fonction des lieux';
PROC SGPLOT DATA = Crack;
	VBOX Prix / CATEGORY = Lieu;
	YAXIS GRID;
RUN;
TITLE 'Prix du crack en fonction des années';
PROC SGPLOT DATA = Crack;
	VBOX Prix / CATEGORY = An;
	YAXIS GRID;
RUN;


/*Etude des lieux pour la meth */
DATA Meth;
	SET BASE_ETUDE (WHERE= (DROGUE = 'Meth'));
RUN;
TITLE 'Prix de la meth en fonction des lieux';
PROC SGPLOT DATA = Meth;
	VBOX Prix / CATEGORY = Lieu;
	YAXIS GRID;
RUN;
TITLE 'Prix de la meth en fonction des années';
PROC SGPLOT DATA = Meth;
	VBOX Prix / CATEGORY = An;
	YAXIS GRID;
RUN;




/* Etude des lieux pour l'heroine */
DATA Hero;
	SET BASE_ETUDE (WHERE= (DROGUE IN ('HerB', 'HerT', 'HerO', 'HerW')));
RUN;
TITLE 'Prix de toutes les heroines en fonction des lieux';
PROC SGPLOT DATA = Hero;
	VBOX Prix / CATEGORY = Lieu;
	YAXIS GRID;
RUN;
TITLE 'Prix de toutes les heroines en fonction des années';
PROC SGPLOT DATA = Hero;
	VBOX Prix / CATEGORY = An;
	YAXIS GRID;
RUN;
/* Grosse baisse en 1985, et aucune vente en 1986, 1987 et 1988 ? */

/* Etude des lieux pour l'heroine B */
DATA HerB;
	SET BASE_ETUDE (WHERE= (DROGUE = 'HerB'));
RUN;

TITLE 'Prix de lhéroine B en fonction des lieux';
PROC SGPLOT DATA = HerB;
	VBOX Prix / CATEGORY = Lieu;
	YAXIS GRID;
RUN;
/* En Ca2, il y a plus de vente */
TITLE 'Prix de lhéroine B en fonction des années';
PROC SGPLOT DATA = HerB;
	VBOX Prix / CATEGORY = An;
	YAXIS GRID;
RUN;



/* Etude des lieux pour l'heroine W */
DATA HerW;
	SET BASE_ETUDE (WHERE= (DROGUE = 'HerW'));
RUN;

TITLE 'Prix de lhéroine W en fonction des lieux';
PROC SGPLOT DATA = HerW;
	VBOX Prix / CATEGORY = Lieu;
	YAXIS GRID;
RUN;
TITLE 'Prix de lhéroine W en fonction des années';
PROC SGPLOT DATA = HerW;
	VBOX Prix / CATEGORY = An;
	YAXIS GRID;
RUN;


/* Etude des lieux pour l'heroine T */
DATA HerT;
	SET BASE_ETUDE (WHERE= (DROGUE = 'HerT'));
RUN;

TITLE 'Prix de lhéroine T en fonction des lieux';
PROC SGPLOT DATA = HerT;
	VBOX Prix / CATEGORY = Lieu;
	YAXIS GRID;
RUN;
TITLE 'Prix de lhéroine T en fonction des années';
PROC SGPLOT DATA = HerT;
	VBOX Prix / CATEGORY = An;
	YAXIS GRID;
RUN;
/* On peut regrouper CA5, CA6, CA7 puis CA2, CA3, CA4  */


/* Etude des lieux pour l'heroine O */
DATA HerO;
	SET BASE_ETUDE (WHERE= (DROGUE = 'HerO'));
RUN;

TITLE 'Prix de lhéroine O en fonction des lieux';
PROC SGPLOT DATA = HerO;
	VBOX Prix / CATEGORY = Lieu;
	YAXIS GRID;
RUN;
/* On peut regrouper CA5, CA6 */

TITLE 'Prix de lhéroine O en fonction des années';
PROC SGPLOT DATA = HerO;
	VBOX Prix / CATEGORY = An;
	YAXIS GRID;
RUN;

/*On remarque que pour les héroines O et W, il y a eu beaucoup de saisie en 1988, contre presque aucune pour les héroines T et B




/* Etude des lieux pour marijuana */
DATA Marijuana;
	SET BASE_ETUDE (WHERE= (DROGUE IN ('MJImp', 'MJDom', 'MJSin')));
RUN;
TITLE 'Prix de toutes les types de marijuana en fonction des lieux';
PROC SGPLOT DATA = Marijuana;
	VBOX Prix / CATEGORY = Lieu;
	YAXIS GRID;
RUN;

TITLE 'Prix de toutes les types de marijuana en fonction de la pureté';
PROC SGPLOT DATA = Marijuana;
	VBOX Prix / CATEGORY = Purete;
	YAXIS GRID;
RUN;

/* La marijuana est toujours pure à 100% */

TITLE 'Prix de toutes les types de marijuana en fonction des années';
PROC SGPLOT DATA = Marijuana;
	VBOX Prix / CATEGORY = An;
	YAXIS GRID;
RUN;
/* Peu dévolution suivant les années globalement */

/* Etude des lieux pour marijuana Imp */
DATA MJImp;
	SET BASE_ETUDE (WHERE= (DROGUE = 'MJImp'));
RUN;
TITLE 'Prix de la marijuana Imp en fonction des lieux';
PROC SGPLOT DATA = MJImp;
	VBOX Prix / CATEGORY = Lieu;
	YAXIS GRID;
RUN;

/* Etude des lieux pour marijuana Dom */
DATA MJDom;
	SET BASE_ETUDE (WHERE= (DROGUE = 'MJDom'));
RUN;

TITLE 'Prix de la marijuana Dom en fonction des lieux';
PROC SGPLOT DATA = MJDom;
	VBOX Prix / CATEGORY = Lieu;
	YAXIS GRID;
RUN;

/* Etude des lieux pour marijuana Sin */
DATA MJSin;
	SET BASE_ETUDE (WHERE= (DROGUE = 'MJSin'));
RUN;
TITLE 'Prix de la marijuana Sin en fonction des lieux';
PROC SGPLOT DATA = MJSin;
	VBOX Prix / CATEGORY = Lieu;
	YAXIS GRID;
RUN;



/* Etude des lieux pour Hashish */

DATA Hashish;
	SET BASE_ETUDE (WHERE= (DROGUE = 'Hash'));
RUN;
TITLE 'Prix du hashish en fonction des lieux';
PROC SGPLOT DATA = Hashish;
	VBOX Prix / CATEGORY = Lieu;
	YAXIS GRID;
RUN;

TITLE 'Prix du hashish en fonction des années';
PROC SGPLOT DATA = Hashish;
	VBOX Prix / CATEGORY = An;
	YAXIS GRID;
RUN;

TITLE 'Prix du hashish en fonction de la pureté';
PROC SGPLOT DATA = Hashish;
	VBOX Prix / CATEGORY = Purete;
	YAXIS GRID;
RUN;

/* Le haschish est toujours pur à 100% */ 

/* Mis à part en 1987 où les prix sont bas, la médiane est à peu près au même niveau */

/* On regroupe (CA1,CA2 et CA3), (CA4, CA5 et CA6), et seuls AK, HA et OR */
/* On regroupe ainsi les lieux géographiquement */
/* Concernant les années, on laisse un découpage en années pour toutes les drogues, les années ayant une influence faible sur les prix lors des saisies, et surtout très variable suivant le type de drogues, on assimile cela à des alées de production ou à des trafiquants actifs particulièrement pour certaines drogues certaines années */
/* On veut maintenant vérifier s'il y a des similitudes entre les drogues */

TITLE 'Prix en fonction du type de drogue';
 PROC SGPLOT DATA = Drogue;
	VBOX Prix / CATEGORY = Drogue;
	YAXIS GRID;
RUN;
TITLE 'Purete en fonction du type de drogue';
 PROC SGPLOT DATA = Drogue;
	VBOX Purete / CATEGORY = Drogue;
	YAXIS GRID;
RUN;
TITLE 'Poids en fonction du type de drogue';
 PROC SGPLOT DATA = Drogue;
	VBOX Poids / CATEGORY = Drogue;
	YAXIS GRID;
RUN;

/* On peut regrouper les différents types de marijuana ensemble, et la cocaine avec le crack */

DATA Californie1;
	SET BASE_ETUDE (WHERE= (Lieu IN ('CA1','CA2','CA3')));
RUN;

DATA Californie2;
	SET BASE_ETUDE (WHERE= (Lieu IN ('CA4', 'CA5','CA6','CA7')));
RUN;

DATA AK;
	SET BASE_ETUDE (WHERE= (Lieu IN ('AK')));
RUN;

DATA Autre1;
	SET BASE_ETUDE (WHERE= (Lieu IN ('OR')));
RUN;
DATA Autre2;
	SET BASE_ETUDE (WHERE= (Lieu IN ('WA')));
RUN;
DATA Autre3;
	SET BASE_ETUDE (WHERE= (Lieu IN ('OR')));
RUN;
DATA CC;
	SET BASE_ETUDE (WHERE= (DROGUE IN ('Crack', 'Coc')));
RUN;

DATA DROGUE ;
SET DROGUE;
LENGTH LIEU_REC $11;
IF LIEU IN ('CA1','CA2','CA3') THEN LIEU_REC = 'Sud';
ELSE IF LIEU IN ('CA4', 'CA5','CA6','CA7') THEN LIEU_REC = 'Nord';
ELSE IF LIEU IN ('AK') THEN LIEU_REC = 'AK';
ELSE IF LIEU IN ('OR') THEN LIEU_REC = 'Autre1';
ELSE IF LIEU IN ('WA') THEN LIEU_REC = 'Autre2';
ELSE IF LIEU IN ('HI') THEN LIEU_REC = 'Autre3';

LENGTH Poids_REC $15.;

IF     Poids <= 330  THEN Poids_REC = 'Low';
ELSE IF Poids <= 860 THEN Poids_REC = 'Medium';
					 ELSE Poids_REC = 'High';
RUN;

DATA DROGUE;
	SET DROGUE;

LENGTH Poids_REC $15.;

IF     Poids <= 330  THEN Poids_REC = 'Low';
ELSE IF Poids <= 860 THEN Poids_REC = 'Medium';
					 ELSE Poids_REC = 'High';
RUN;
/* Dichotomie des variables */

/* On étude la marijuana et les autres drogues de manière séparée */

DATA BASE_ETUDE;
	SET DROGUE;
COCK = (DROGUE=('Coc'));
CRACK =(DROGUE=('Crack'));
METH = (DROGUE=('Meth'));
HEROO = (DROGUE=('HerO'));
HEROB = (DROGUE=('HerB'));
HEROW = (DROGUE=('HerW'));
HEROT = (DROGUE=('HerT'));

LIEU_1 = (LIEU_REC=('Sud'));
LIEU_2 = (LIEU_REC=('Nord'));
LIEU_3 = (LIEU_REC=('AK'));
LIEU_4 = (LIEU_REC=('Autre1'));
LIEU_5 = (LIEU_REC=('Autre2'));
LIEU_6 = (LIEU_REC=('Autre3'));

POIDS_LOW = (POIDS_REC =('Low'));
POIDS_MEDIUM = (POIDS_REC =('Medium'));
POIDS_HIGH = (POIDS_REC =('High'));

Prix_LOG   = LOG(Prix);
Prix_SQRT   = SQRT(Prix);
RUN;

DATA BASE_ETUDE;
	SET DROGUE;
MJ_SIN = (DROGUE=('MJSin'));
MJ_DOM = (DROGUE=('MJDom'));
MJ_IMP = (DROGUE=('MJImp'));
HASH = (DROGUE=('Hash'));

LIEU_1 = (LIEU_REC=('Sud'));
LIEU_2 = (LIEU_REC=('Nord'));
LIEU_3 = (LIEU_REC=('AK'));
LIEU_4 = (LIEU_REC=('Autre1'));
LIEU_5 = (LIEU_REC=('Autre2'));
LIEU_6 = (LIEU_REC=('Autre3'));

POIDS_LOW = (POIDS_REC =('Low'));
POIDS_MEDIUM = (POIDS_REC =('Medium'));
POIDS_HIGH = (POIDS_REC =('High'));

Prix_LOG   = LOG(Prix);
Prix_SQRT   = SQRT(Prix);


RUN;


/* Cible avec toutes les variables */
PROC REG DATA = BASE_ETUDE SIMPLE;
MODEL Prix = COCK METH HEROO HEROB HEROW HEROT CRACK
			 LIEU_1 LIEU_2 LIEU_3 LIEU_4 LIEU_5 LIEU_6
			 An
			 POIDS_LOW POIDS_MEDIUM POIDS_HIGH
			 Purete;
RUN;
PLOT R.* NQQ.;		  /* Droite d'Henry */
PLOT R. * PREDICTED.; /* Graphe des résidus */
QUIT;


/* LOG Cible avec toutes les variables */
PROC REG DATA = BASE_ETUDE SIMPLE;
MODEL Prix_LOG = COCK METH HEROO HEROB HEROW HEROT CRACK
			 LIEU_1 LIEU_2 LIEU_3 LIEU_4 LIEU_5 LIEU_6
			 An
			 POIDS_LOW POIDS_MEDIUM POIDS_HIGH
			 Purete;

RUN;
PLOT R.* NQQ.;		  /* Droite d'Henry */
PLOT R. * PREDICTED.; /* Graphe des résidus */
QUIT;

/* SQRT Cible avec toutes les variables */
PROC REG DATA = BASE_ETUDE SIMPLE;
MODEL Prix_SQRT = COCK METH HEROO HEROB HEROW HEROT CRACK
			 LIEU_1 LIEU_2 LIEU_3 LIEU_4  LIEU_5 LIEU_6
			 An
			 POIDS_LOW POIDS_MEDIUM POIDS_HIGH
			 Purete;

RUN;
PLOT R.* NQQ.;		  /* Droite d'Henry */
PLOT R. * PREDICTED.; /* Graphe des résidus */
QUIT;

/* Idem pour la marijuana maintenant */

/* Cible avec toutes les variables */
PROC REG DATA = BASE_ETUDE SIMPLE;
MODEL Prix = MJ_SIN MJ_DOM MJ_IMP HASH
			 LIEU_1 LIEU_2 LIEU_3 LIEU_4 LIEU_5 LIEU_6
			 An
			 POIDS_LOW POIDS_MEDIUM POIDS_HIGH;
RUN;
PLOT R.* NQQ.;		  /* Droite d'Henry */
PLOT R. * PREDICTED.; /* Graphe des résidus */
QUIT;


/* LOG Cible avec toutes les variables */
PROC REG DATA = BASE_ETUDE SIMPLE;
MODEL Prix_LOG = MJ_SIN MJ_DOM MJ_IMP HASH
			 LIEU_1 LIEU_2 LIEU_3 LIEU_4 LIEU_5 LIEU_6
			 An
			 POIDS_LOW POIDS_MEDIUM POIDS_HIGH;

RUN;
PLOT R.* NQQ.;		  /* Droite d'Henry */
PLOT R. * PREDICTED.; /* Graphe des résidus */
QUIT;

/* SQRT Cible avec toutes les variables */
PROC REG DATA = BASE_ETUDE SIMPLE;
MODEL Prix_SQRT = MJ_SIN MJ_DOM MJ_IMP HASH
			 LIEU_1 LIEU_2 LIEU_3 LIEU_4 LIEU_5 LIEU_6
			 An
			 POIDS_LOW POIDS_MEDIUM POIDS_HIGH;

RUN;
PLOT R.* NQQ.;		  /* Droite d'Henry */
PLOT R. * PREDICTED.; /* Graphe des résidus */
QUIT;