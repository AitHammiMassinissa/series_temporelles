import java.util.Arrays;
import java.util.stream.Collectors;



/***********************Déclaration de variable*****************************/

FloatTable donnees;
Integrator[] values;
float dmin, dmax;
int amin, amax;
int[] annees;
float traceX1, traceY1, traceX2, traceY2;
// La colonne de données actuellement utilisée.
int colonne = 0;
// Le nombre de colonnes.
int nombre_colonnes;
// La police de caractères.
PFont police;
//touche clavier à utiliser
char[] availableModes = {'p', 'a', 'h', 'l', 'd'};
char mode = 'p';

int intervalleAnnees = 10;
int intervalleVolume = 10;
int intervalleVolumeMineur = 5;


/********************************Setup()********************************/


void setup() {
    size(1280, 800);

    donnees = new FloatTable("../data/lait-the-cafe.tsv");
    nombre_colonnes = donnees.getColumnCount(); // Le nombre de colonnes.
    dmin = 0;
    dmax = ceil(donnees.getTableMax() / intervalleVolume) * intervalleVolume;
    annees = int(donnees.getRowNames());
    amin = annees[0];
    amax = annees[annees.length - 1];

    traceX1 = 170;
    traceY1 = 50;
    traceX2 = width - 50;
    traceY2 = height - traceY1;
  
     police = createFont("Georgia", 32); 
     textFont(police);
 
    int rowCount = donnees.getRowCount();
    values = new Integrator[rowCount];
    for(int i = 0; i < rowCount; ++i) {
        values[i] = new Integrator(donnees.getFloat(i, colonne), 0.3, 0.15);
    }

    smooth();
}


/***********************************draw()**********************************/

void draw() {
    background(224);

    fill(255);
    rectMode(CORNERS);
    noStroke();
    rect(traceX1, traceY1, traceX2, traceY2);
    
    // Actualisation des valeurs
    for(int i = 0; i < donnees.getRowCount(); ++i) {
        values[i].update();
    }

    Dessiner_Titre(); // Dessine le titre.

    if(mode == 'a') Dessine_Mode_Aire(colonne); // Dessin des aires avant pour avoir l'axe devant
    Dessine_Axe_Annees(); // Dessin de l'axe des années
    Dessine_Axe_Volume(); // Dessin de l'axe des volumes

    switch(mode) {
        case 'p':
            Dessine_Mode_Points(colonne);
            break;
        case 'h':
            Dessine_Mode_Histograme(colonne);
            break;
        case 'l':
            Dessine_Mode_Ligne(colonne);
            break;
        case 'd':
            Dessine_Mode_Ligne_Points(colonne);
            break;
    }

    textSize(15);
    textAlign(CENTER, CENTER);
    Dessiner_Tooltip();
    textAlign(LEFT, CENTER);
    textSize(10);
    fill(0);
    text("Touche --> Mode\n \n p ==>points\na ==> aire\nh ==> histogramme\nl==> ligne\nd==> ligne + points", 10, height-100);
}



/***********************Methode de dessin pour les mode***************************/


      /*############### Mode ligne ##########################*/
      
void Dessine_Mode_Ligne(int col) {
    beginShape();   // On commence la ligne.
    strokeWeight(5);
    stroke(#5679C1);
    noFill();
    int lignes = donnees.getRowCount();
    for(int ligne = 0; ligne < lignes; ligne++) {
        if(donnees.isValid(ligne, col)) {
            float valeur = values[ligne].value;
            float x = map(annees[ligne], amin, amax, traceX1, traceX2);
            float y = map(valeur, dmin, dmax, traceY2, traceY1);
            vertex(x, y);
        }
    }
    endShape(); // On termine la ligne sans fermer la forme.
}


          /*############### Mode point ##########################*/
          
          
void Dessine_Mode_Points(int col) {
    strokeWeight(5);
    stroke(#5679C1);
    int lignes = donnees.getRowCount();
    for(int ligne = 0; ligne < lignes; ligne++) {
        if(donnees.isValid(ligne, col)) {
            //float valeur = donnees.getFloat(ligne, col);
            float valeur = values[ligne].value;
            float x = map(annees[ligne], amin, amax, traceX1, traceX2);
            float y = map(valeur, dmin, dmax, traceY2, traceY1);
            point(x, y);
        }
    }
}

            /*############### Mode ligne et point en meme temps ###################*/

void Dessine_Mode_Ligne_Points(int col) {
    beginShape();   // On commence la ligne.
    strokeWeight(1);
    stroke(#5679C1);
    noFill();
    int lignes = donnees.getRowCount();
    for(int ligne = 0; ligne < lignes; ligne++) {
        if(donnees.isValid(ligne, col)) {
            float valeur = values[ligne].value;
            float x = map(annees[ligne], amin, amax, traceX1, traceX2);
            float y = map(valeur, dmin, dmax, traceY2, traceY1);
            vertex(x, y);
            strokeWeight(5);
            point(x, y);
            strokeWeight(1);
        }
    }
    endShape(); // On termine la ligne sans fermer la forme.
}


        /*############### Mode Histogramme ##########################*/
        
        
        
void Dessine_Mode_Histograme(int col) {
    stroke(#5679C1);
    fill(#5679C1);
    int lignes = donnees.getRowCount();
    for(int ligne = 0; ligne < lignes; ligne++) {
        if(donnees.isValid(ligne, col)) {
            float valeur = values[ligne].value;
            float x = map(annees[ligne], amin, amax, traceX1, traceX2);
            float y = map(valeur, dmin, dmax, traceY2, traceY1);
            if(ligne == 0) rect(x, y, x+3, traceY2-1);
            else if(ligne == lignes-1) rect(x-4, y, x-1, traceY2-1);
            else rect(x-2, y, x+2, traceY2-1);
        }
    }
}

        /*############### Mode Aire ##########################*/
        
void Dessine_Mode_Aire(int col) {
    beginShape();   // On commence la ligne.
    strokeWeight(1);
    stroke(#5679C1);
    fill(#5679C1);
    vertex(traceX1, traceY2);
    int lignes = donnees.getRowCount();
    for(int ligne = 0; ligne < lignes; ligne++) {
        if(donnees.isValid(ligne, col)) {
            float valeur = values[ligne].value;
            float x = map(annees[ligne], amin, amax, traceX1, traceX2);
            float y = map(valeur, dmin, dmax, traceY2, traceY1);
            vertex(x, y);
        }
    }
    vertex(traceX2, traceY2);
    endShape(CLOSE);
}

/***********************Methode de dessin pour les axes ***************************/

          /*############### Dessiner l'axe des annnees #################*/
          
void Dessine_Axe_Annees() {
    fill(0);
    textSize(10);
    textAlign(CENTER, TOP);

    // Des lignes fines en gris clair.
    stroke(224);
    strokeWeight(1);

    int lignes = donnees.getRowCount();
    for(int ligne = 0; ligne < lignes; ligne++) {
        if(annees[ligne] % intervalleAnnees == 0) {
            float x = map(annees[ligne], amin, amax, traceX1, traceX2);
            text(annees[ligne], x, traceY2 + 10);
            // Dessine les lignes.
            line(x, traceY1, x, traceY2);
        }
    }
    textAlign(CENTER);
    textSize(15);
    text("Années", width/2, traceY2 + 40);
    textAlign(0);
}

        /*############### Dessiner l'axe des volumes #################*/

void Dessine_Axe_Volume() {
    fill(0);
    textSize(10);
    stroke(128);
    strokeWeight(1);

    for(float v = dmin; v <= dmax; v+=intervalleVolumeMineur) {
        if(v % intervalleVolumeMineur == 0) {
            float y = map(v, dmin, dmax, traceY2, traceY1);
            if(v % intervalleVolume == 0) {
                if(v == dmin) {
                    textAlign(RIGHT, BOTTOM);
                } else if(v == dmax) {
                    textAlign(RIGHT, TOP);
                } else {
                    textAlign(RIGHT, CENTER);
                }
                text(floor(v), traceX1 - 10, y);
                line(traceX1 - 4, y, traceX1, y); // Tiret majeur.
            } else {
                line(traceX1 - 2, y, traceX1, y); // Tiret mineur.
            }
        }
    }
    textAlign(CENTER, CENTER);
    textSize(15);
    text("Litres\nconsommés\npar pers.", traceX1/2, height/2);
    textAlign(0);
}
/***********************Methode de dessin pour le titre ***************************/

void Dessiner_Titre() {
  
    fill(0);
    textSize(20);
    textAlign(CENTER);
    text(donnees.getColumnName(colonne), width/2, traceY1 - 10); 
}

/**********************Dessiner les tooltip ********************************/


void Dessiner_Tooltip() {
    // Guard case si la souris n'est pas dans le graph
    if(!(mouseX > traceX1-2 && mouseX < traceX2+2 && mouseY > traceY1 && mouseY < traceY2)) return;
    switch(mode) {
        case 'p':
        case 'd':
        case 'l':
            Dessiner_Tooltip_Point();
            break;
        case 'a':
            Dessiner_Tooltip_Aire();
            break;
        case 'h':
            Dessiner_Tooltip_Histo();
            break;
    }
}

void Dessiner_Tooltip_Point() {
    for(int i = 0; i < donnees.getRowCount(); ++i) {
        float valeur = values[i].value;
        float x = map(annees[i], amin, amax, traceX1, traceX2);
        float y = map(valeur, dmin, dmax, traceY2, traceY1);
        // Distance entre la souris et le point
        float dist = (float) Math.sqrt((mouseY - y)*(mouseY - y) + (mouseX - x)*(mouseX - x));
        if(dist < 5) {
            stroke(#333333);
            fill(#333333);
            rect(mouseX-50, mouseY-27, mouseX+50, mouseY-9, 2);
            fill(#FFFFFF);
            text(annees[i] + " : " + String.format("%.2f", valeur), mouseX, mouseY-20);
        }
    }
}

void Dessiner_Tooltip_Histo() {
    int lignes = donnees.getRowCount();
    for(int i = 0; i < lignes; ++i) {
        float valeur = values[i].value;
        float x = map(annees[i], amin, amax, traceX1, traceX2);
        float y = map(valeur, dmin, dmax, traceY2, traceY1);
        // Si la souris est dans l'histo
        boolean in;
        if(i == 0) in = mouseX > x && mouseX < x+4 && mouseY > y && mouseY < traceY2;
        else if(i == lignes-1) in = mouseX > x-4 && mouseX < x && mouseY > y && mouseY < traceY2;
        else in = mouseX > x-2 && mouseX < x+2 && mouseY > y && mouseY < traceY2;
        if(in) {
            fill(#94bdff);
            stroke(#94bdff);
            if(i == 0) rect(x, y, x+3, traceY2-1);
            else if(i == lignes-1) rect(x-4, y, x-1, traceY2-1);
            else rect(x-2, y, x+2, traceY2-1);
            stroke(#333333);
            fill(#333333);
            rect(mouseX-50, mouseY-27, mouseX+50, mouseY-9, 2);
            fill(#FFFFFF);
            text(annees[i] + " : " + String.format("%.2f", valeur), mouseX, mouseY-20);
        }
    }
}

void Dessiner_Tooltip_Aire() {
    for(int i = 0; i < donnees.getRowCount(); ++i) {
        float valeur = values[i].value;
        float x = map(annees[i], amin, amax, traceX1, traceX2);
        float y = map(valeur, dmin, dmax, traceY2, traceY1);
        // Si la souris est assez proche en x et dans la couleur
        boolean in = mouseX > x-3 && mouseX < x+3 && mouseY > y && mouseY < traceY2;
        if(in) {
            stroke(224);
            line(x, traceY1, x, traceY2);
            stroke(#333333);
            fill(#333333);
            rect(mouseX-50, mouseY-27, mouseX+50, mouseY-9, 2);
            fill(#FFFFFF);
            text(annees[i] + " : " + String.format("%.2f", valeur), mouseX, mouseY-20);
        }
    }
}





/*************************Presser sur une touche **********************/


void keyPressed() {
    if(keyCode == LEFT) {
        colonne = colonne == 0 ? nombre_colonnes - 1 : (colonne - 1);
        for(int i = 0; i < donnees.getRowCount(); i++) {
            values[i].target(donnees.getFloat(i, colonne));
        }
    }else if(keyCode == RIGHT) {
        colonne = (colonne + 1) % nombre_colonnes;
        for(int i = 0; i < donnees.getRowCount(); i++) {
            values[i].target(donnees.getFloat(i, colonne));
        }
    }else {
        String modes = new String(availableModes);
        if(modes.indexOf(Character.toLowerCase(key)) != -1)
            mode = Character.toLowerCase(key);
    }
}
