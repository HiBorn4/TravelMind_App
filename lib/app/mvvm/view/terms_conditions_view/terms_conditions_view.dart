import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../../config/app_assets.dart';
import '../../../config/app_colors.dart';
import '../../../customWidgets/custom_app_bar.dart';

class TermsConditionsView extends StatelessWidget {
  const TermsConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        toolBarHeight: 70.h,
        title: context.l10n!.terms_conditions,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        ),
      ),
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.scaffoldBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'TERMENI ȘI CONDIȚII (TERMS & CONDITIONS)',
                  style: AppTextStyles.customText18(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                16.verticalSpace,
                Text(
                  'VladAI',
                  style: AppTextStyles.customText16(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                8.verticalSpace,
                Text(
                  'Operator: Tech-Hub Horizon SRL – CUI 46003331\nSediu: Borșa, jud. Maramureș, Str. Negoiului nr. 2C, România\nEmail contact: vladairomania@gmail.com',
                  style: AppTextStyles.customText14(
                    color: AppColors.black.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                24.verticalSpace,

                // Section 1
                _buildSectionTitle('1. Acceptarea Termenilor'),
                _buildParagraph(
                  'Prezentele Termeni și Condiții („Termeni") constituie un acord juridic obligatoriu între Tech-Hub Horizon SRL („Operatorul", „noi") și orice persoană care accesează sau utilizează aplicația mobilă VladAI („Aplicația") și serviciile puse la dispoziție prin intermediul acesteia („Serviciile"). Termenii se aplică indiferent dacă utilizatorul accesează Aplicația ca vizitator, ca utilizator înregistrat sau prin orice altă modalitate de acces oferită de Aplicație.',
                ),
                _buildParagraph(
                  'Prin descărcarea, instalarea, accesarea, crearea unui cont, autentificarea și/sau utilizarea Aplicației, confirmi în mod expres că:\n• ai citit integral acești Termeni;\n• ai înțeles conținutul și efectele lor juridice;\n• accepți să fii obligat(ă) de acești Termeni și să îi respecți pe durata utilizării Aplicației.',
                ),
                _buildParagraph(
                  'Dacă nu ești de acord, în tot sau în parte, cu acești Termeni, nu ai dreptul să utilizezi Aplicația sau Serviciile, iar singurul remediu este să încetezi accesarea/utilizarea Aplicației și, după caz, să o dezinstalezi.',
                ),
                _buildParagraph(
                  'În situația în care utilizezi Aplicația în numele unei alte persoane sau entități (de exemplu, în calitate de reprezentant, delegat sau persoană autorizată), declari și garantezi că:\n• deții autoritatea legală necesară pentru a accepta acești Termeni în numele acelei persoane/entități;\n• persoana/entitatea respectivă este de acord să fie obligată de acești Termeni;\n• accepți acești Termeni în numele persoanei/entității respective, iar orice utilizare a Aplicației va fi considerată ca fiind realizată cu acordul acesteia.',
                ),
                _buildParagraph(
                  'Acești Termeni se completează cu Politica de confidențialitate a VladAI, care face parte integrantă din relația dintre utilizator și Operator în ceea ce privește prelucrarea datelor cu caracter personal.',
                ),

                // Section 2
                _buildSectionTitle('2. Descrierea Serviciilor'),
                _buildParagraph(
                  'VladAI este o aplicație mobilă de tip travel planning și travel assistant, destinată sprijinirii utilizatorilor în procesul de informare și planificare a activităților turistice. Prin intermediul Aplicației, utilizatorii pot accesa funcționalități care facilitează descoperirea de locații și organizarea unui plan de vizitare, în funcție de preferințele introduse de utilizator și de conținutul disponibil în Aplicație.',
                ),
                _buildSubSection('2.1', 'Informații și recomandări turistice',
                    'Aplicația poate furniza informații și sugestii cu privire la:\n• atracții turistice, obiective culturale și puncte de interes;\n• restaurante și locații de tip food & beverage;\n• opțiuni de cazare sau zone recomandate pentru cazare;\n• activități, experiențe și alte recomandări relevante pentru planificarea unei călătorii.\n\nInformațiile oferite au caracter orientativ și sunt furnizate în scop informativ, în funcție de disponibilitatea datelor și de modul în care utilizatorul formulează solicitările sau preferințele în cadrul Aplicației.'),
                _buildSubSection('2.2', 'Vizualizarea locațiilor pe hartă',
                    'Aplicația permite afișarea pe hartă a anumitor locații și puncte de interes, precum și vizualizarea acestora în raport cu itinerariile generate sau cu sugestiile oferite. Funcționalitatea de hartă este destinată exclusiv orientării și planificării. Operatorul nu garantează că:\n• toate locațiile afișate sunt complete sau actualizate în orice moment;\n• localizarea exactă, programul sau disponibilitatea unei locații este corectă în toate situațiile.'),
                _buildSubSection('2.3', 'Generarea de itinerarii personalizate',
                    'Aplicația poate genera itinerarii de călătorie personalizate, inclusiv propuneri de activități organizate pe zile și/sau intervale orare, pe baza:\n• informațiilor introduse de utilizator (de ex.: oraș, durată, preferințe);\n• logicii interne a sistemelor automatizate utilizate de Aplicație.\n\nItinerariile sunt propuneri orientative. Utilizatorul rămâne responsabil pentru verificarea detaliilor esențiale (de ex.: program, acces, tarife, disponibilitate, restricții, condiții meteo, siguranță).'),
                _buildSubSection('2.4', 'Salvarea itinerariilor în contul utilizatorului',
                    'Itinerariile generate pot fi salvate și asociate contului utilizatorului, astfel încât utilizatorul să le poată accesa ulterior, revizui, modifica sau reutiliza, în funcție de funcționalitățile disponibile în Aplicație.\n\nUtilizatorul înțelege și acceptă că această funcționalitate presupune stocarea itinerariilor și a informațiilor aferente în bazele de date ale Operatorului, conform Politicii de confidențialitate.'),
                _buildSubSection('2.5', 'Disponibilitatea Serviciilor. Caracterul dinamic al aplicației',
                    'Serviciile sunt furnizate în forma disponibilă la momentul utilizării („as is" / „as available"), iar Operatorul își rezervă dreptul de a:\n• actualiza, modifica, îmbunătăți sau elimina anumite funcționalități;\n• introduce limite tehnice (de exemplu, în funcție de capacitate, mentenanță, actualizări);\n• suspenda temporar sau permanent anumite servicii, din motive tehnice, legale sau comerciale.\n\nOrice modificări vor fi gestionate conform dispozițiilor secțiunii 10 din acești Termeni.'),

                // Section 3
                _buildSectionTitle('3. Eligibilitate. Vârsta minimă'),
                _buildParagraph(
                  'Aplicația VladAI și Serviciile furnizate prin intermediul acesteia sunt destinate exclusiv persoanelor care au împlinit vârsta de 18 ani. Prin accesarea și utilizarea Aplicației, utilizatorul declară și garantează că are cel puțin 18 ani și că are capacitatea legală deplină de a încheia un acord obligatoriu din punct de vedere juridic, în conformitate cu legislația aplicabilă.',
                ),
                _buildParagraph(
                  'În cazul în care un utilizator nu a împlinit vârsta de 18 ani, acesta nu este autorizat să utilizeze Aplicația, să își creeze un cont sau să acceseze Serviciile, indiferent de modalitatea de acces sau de existența unui acord/consimțământ din partea părinților ori reprezentanților legali.',
                ),
                _buildParagraph(
                  'Operatorul își rezervă dreptul de a adopta măsuri rezonabile pentru a verifica respectarea acestei cerințe și de a restricționa, suspenda sau închide conturile despre care există indicii rezonabile că aparțin unor persoane sub 18 ani, fără obligația de a notifica în prealabil utilizatorul, în măsura permisă de lege.',
                ),
                _buildParagraph(
                  'Dacă ești părinte sau reprezentant legal și consideri că un minor a creat un cont sau a furnizat date prin intermediul Aplicației, te rugăm să ne contactezi la vladairomania@gmail.com, pentru a putea lua măsurile necesare, inclusiv ștergerea contului și/sau a datelor asociate, în conformitate cu Politica de confidențialitate și legislația aplicabilă.',
                ),

                // Section 4
                _buildSectionTitle('4. Contul de utilizator. Corectitudinea informațiilor'),
                _buildParagraph(
                  'Pentru accesarea și utilizarea anumitor funcționalități ale Aplicației VladAI (inclusiv generarea și salvarea itinerariilor), este necesară crearea unui cont de utilizator. În cadrul procesului de înregistrare, utilizatorul poate fi solicitat să furnizeze date precum: nume, prenume, adresă de email, număr de telefon și locație generală (țară/oraș). Operatorul poate solicita, de asemenea, informații suplimentare necesare pentru funcționarea Aplicației, în funcție de evoluția serviciilor și de funcționalitățile implementate.',
                ),
                _buildSubSection('4.1', 'Obligația de furnizare a unor informații corecte',
                    'Prin crearea contului, utilizatorul declară și garantează că toate informațiile furnizate sunt reale, exacte, complete și actualizate și se obligă să le mențină actualizate ori de câte ori intervin modificări relevante. Utilizatorul înțelege că furnizarea de informații incorecte, incomplete sau înșelătoare poate afecta funcționarea Aplicației și poate conduce la limitarea accesului la Servicii.'),
                _buildSubSection('4.2', 'Responsabilitatea utilizatorului pentru activitatea din cont',
                    'Utilizatorul este singurul responsabil pentru toate activitățile desfășurate prin intermediul contului său, inclusiv pentru:\n• utilizarea funcționalităților Aplicației;\n• generarea, salvarea și modificarea itinerariilor;\n• orice acțiuni efectuate de o persoană care obține acces la cont, cu sau fără acordul utilizatorului, ca urmare a neglijenței utilizatorului în protejarea datelor de acces.'),
                _buildSubSection('4.3', 'Securitatea contului și confidențialitatea datelor de acces',
                    'Utilizatorul se obligă să păstreze confidențialitatea datelor de autentificare și să ia toate măsurile rezonabile pentru a preveni accesul neautorizat la cont. În mod special, utilizatorul nu va divulga datele de acces către terți și nu va permite utilizarea contului său de către alte persoane.'),
                _buildSubSection('4.4', 'Notificarea accesului neautorizat',
                    'În cazul în care utilizatorul suspectează sau constată:\n• acces neautorizat la cont;\n• utilizarea contului fără permisiune;\n• orice incident de securitate care ar putea compromite contul,\n\nutilizatorul se obligă să ne informeze fără întârziere la adresa de email: vladairomania@gmail.com, pentru a putea lua măsurile rezonabile disponibile (de exemplu, investigarea incidentului, restricționarea accesului, recomandări de securitate). Operatorul nu poate fi ținut răspunzător pentru prejudicii cauzate de neîndeplinirea de către utilizator a obligației de notificare într-un termen rezonabil.'),
                _buildSubSection('4.5', 'Dreptul Operatorului de a suspenda sau restricționa contul',
                    'Ne rezervăm dreptul de a suspenda, restricționa sau închide contul, în măsura permisă de lege, atunci când există indicii rezonabile că:\n• informațiile furnizate sunt false sau înșelătoare;\n• contul este utilizat în mod abuziv, fraudulos sau contrar acestor Termeni;\n• securitatea Aplicației sau a altor utilizatori este pusă în pericol.\n\nOrice astfel de măsuri se vor aplica în conformitate cu secțiunea privind suspendarea/încetarea accesului, fără a aduce atingere drepturilor legale ale utilizatorului.'),

                // Section 5
                _buildSectionTitle('5. Prelucrarea datelor, sisteme AI și servicii terțe'),
                _buildParagraph(
                  'Utilizarea Aplicației VladAI implică, în mod necesar, anumite operațiuni tehnice și funcționale fără de care Serviciile nu pot fi furnizate în mod corespunzător. Prin acceptarea acestor Termeni și utilizarea Aplicației, utilizatorul înțelege și acceptă că:',
                ),
                _buildNumberedSection('1', 'Prelucrarea și stocarea datelor necesare funcționării',
                    'Pentru a permite crearea, generarea, salvarea, accesarea ulterioară și administrarea itinerariilor, precum și funcționarea contului de utilizator și a Serviciilor asociate, Aplicația poate prelucra și stoca date introduse de utilizator și date generate în urma utilizării Aplicației, inclusiv itinerariile create. În lipsa acestei prelucrări și stocări, funcționarea Aplicației și furnizarea Serviciilor esențiale ar fi imposibile sau semnificativ afectate. Dacă utilizatorul nu este de acord cu aceste operațiuni indispensabile, acesta trebuie să înceteze utilizarea Aplicației.'),
                _buildNumberedSection('2', 'Utilizarea sistemelor automatizate (AI) și limitările acestora',
                    'Aplicația poate utiliza sisteme automatizate, inclusiv tehnologii bazate pe inteligență artificială, pentru a genera răspunsuri, recomandări și itinerarii. Utilizatorul recunoaște că interacționează cu un sistem automat, nu cu un operator uman, iar rezultatele furnizate au caracter orientativ și pot depinde de informațiile introduse și de datele disponibile. Utilizatorul se obligă să nu introducă în Aplicație informații sensibile (de exemplu: parole, date bancare, date medicale, date de identificare oficială), fiind responsabil pentru conținutul furnizat.'),
                _buildNumberedSection('3', 'Integrarea serviciilor terțe',
                    'Anumite funcționalități ale Aplicației pot utiliza servicii furnizate de terți precum Mapbox si Google Analytics. Utilizatorul înțelege că aceste servicii terțe pot prelucra date tehnice necesare funcționării lor, conform propriilor politici și termeni, iar Operatorul nu controlează în mod direct modul în care acești furnizori prelucrează datele în nume propriu.'),
                _buildNumberedSection('4', 'Document de referință',
                    'Detaliile privind categoriile de date prelucrate, scopurile, temeiurile legale, perioadele de stocare, drepturile utilizatorilor și măsurile de protecție sunt descrise în Politica de confidențialitate a VladAI, care se consideră parte integrantă din relația dintre utilizator și Operator. În cazul oricăror neconcordanțe, prevederile Politicii de confidențialitate prevalează cu privire la aspectele care țin de protecția datelor cu caracter personal, în măsura permisă de lege.'),

                // Section 6
                _buildSectionTitle('6. Condiții de acces și utilizare. Conduita utilizatorului'),
                _buildSubSection('6.1', 'Responsabilitatea utilizatorului pentru conținut',
                    'Utilizatorul este exclusiv responsabil pentru orice informații, date, texte, mesaje, preferințe, solicitări, conținut sau alte materiale pe care le introduce, transmite sau pune la dispoziție prin intermediul Aplicației VladAI (denumite în continuare, în mod colectiv, „Conținutul utilizatorului").\n\nUtilizatorul declară și garantează că:\n• deține toate drepturile necesare asupra Conținutului utilizatorului sau are dreptul legal de a-l furniza;\n• Conținutul utilizatorului nu încalcă drepturi de proprietate intelectuală, drepturi la viață privată sau alte drepturi ale unor terți;\n• Conținutul utilizatorului respectă legislația aplicabilă și prezentele Termeni.'),
                _buildSubSection('6.2', 'Utilizări interzise ale Aplicației',
                    'Este strict interzisă utilizarea Aplicației VladAI în orice mod ilegal, abuziv sau neautorizat. Fără a se limita la acestea, utilizatorul se obligă să nu utilizeze Aplicația pentru a:\n\n1. introduce, transmite sau pune la dispoziție orice conținut care:\n• încalcă drepturi de autor, mărci, brevete sau alte drepturi de proprietate intelectuală ale unor terți;\n• este ilegal, fraudulos, înșelător, dăunător, amenințător, abuziv, hărțuitor, defăimător, obscen, pornografic, discriminatoriu, instigator la ură sau violență;\n• încalcă dreptul la viață privată sau securitatea altor persoane;\n• conține viruși, malware, cod malițios sau alte programe destinate să afecteze funcționarea Aplicației, a dispozitivelor sau a rețelelor.\n\n2. transmite mesaje comerciale neautorizate, publicitate nesolicitată, spam, scheme piramidale, concursuri neautorizate sau orice formă de solicitare nepermisă;\n\n3. se dea drept o altă persoană sau entitate ori să furnizeze informații false privind identitatea sau afilierea sa;\n\n4. colecteze, extragă sau încerce să obțină date despre alți utilizatori (inclusiv adrese de email sau date de contact), prin mijloace automate sau manuale, fără autorizare;\n\n5. acceseze, încerce să acceseze sau să obțină informații, date, funcționalități sau sisteme care nu sunt puse la dispoziție în mod intenționat prin Aplicație;\n\n6. interfereze cu funcționarea Aplicației, a serverelor sau a rețelelor asociate, inclusiv prin supraîncărcare, atacuri de tip denial-of-service sau alte acțiuni similare;\n\n7. ocolească, dezactiveze sau încerce să eludeze măsuri de securitate, limitări tehnice sau restricții de acces impuse de Aplicație;\n\n8. utilizeze instrumente automate precum roboți, scraping, data mining, crawling sau alte metode similare de colectare sau extragere a datelor;\n\n9. utilizeze Aplicația sau conținutul acesteia pentru a dezvolta, promova sau furniza produse ori servicii concurente VladAI, fără acordul scris al Operatorului;\n\n10. încalce orice lege sau reglementare locală, națională sau internațională aplicabilă.'),
                _buildSubSection('6.3', 'Măsuri și sancțiuni',
                    'Tech-Hub Horizon SRL își rezervă dreptul, la libera sa apreciere și în limitele permise de lege, de a:\n• investiga orice utilizare a Aplicației care încalcă acești Termeni;\n• elimina sau restricționa accesul la Conținutul utilizatorului;\n• suspenda sau închide contul utilizatorului;\n• restricționa accesul la Aplicație (inclusiv prin blocarea IP-ului);\n• sesiza autoritățile competente, dacă faptele pot constitui încălcări ale legii.'),
                _buildSubSection('6.4', 'Interdicția de eludare a restricțiilor',
                    'În cazul în care accesul unui utilizator la Aplicație este restricționat sau blocat, utilizatorul se obligă să nu încerce să ocolească aceste măsuri prin mijloace tehnice (de exemplu, utilizarea de VPN-uri, proxy-uri, conturi multiple sau alte metode similare).'),

                // Section 7
                _buildSectionTitle('7. Drepturi de proprietate intelectuală'),
                _buildSubSection('7.1', 'Conținutul și drepturile asupra Aplicației',
                    'Aplicația VladAI, precum și toate elementele care o compun sau sunt puse la dispoziție prin intermediul acesteia, inclusiv, fără a se limita la:\n• designul, interfața, structura și arhitectura aplicației;\n• textele, descrierile, conținutul informativ, grafica, logo-urile și elementele vizuale;\n• funcționalitățile, fluxurile de utilizare și logica aplicației;\n• sistemele automatizate, algoritmii, modelele AI, structurile de date și rezultatele generate;\n• codul sursă și codul obiect;\n\n(denumite în continuare, în mod colectiv, „Conținutul Aplicației") sunt protejate de legislația privind drepturile de autor, mărcile, secretele comerciale și alte drepturi de proprietate intelectuală și aparțin Tech-Hub Horizon SRL și/sau partenerilor ori licențiatorilor săi, după caz.\n\nNicio prevedere din acești Termeni nu conferă utilizatorului dreptul de proprietate asupra Conținutului Aplicației.'),
                _buildSubSection('7.2', 'Licența acordată utilizatorului',
                    'Sub rezerva respectării acestor Termeni, utilizatorului i se acordă o licență limitată, neexclusivă, netransferabilă, revocabilă și fără drept de sublicențiere, de a accesa și utiliza Aplicația VladAI exclusiv în scop personal, necomercial, în conformitate cu funcționalitățile puse la dispoziție.\n\nEste strict interzis ca utilizatorul să:\n• copieze, modifice, adapteze, traducă sau creeze opere derivate din Aplicație sau Conținutul Aplicației;\n• reproducă, distribuie, afișeze public, vândă, închirieze, sublicențieze sau exploateze comercial Aplicația sau Conținutul acesteia;\n• extragă, colecteze sau utilizeze datele, structura, rezultatele sau conținutul Aplicației prin metode automate (scraping, crawling, data mining etc.);\n• încerce să obțină acces la codul sursă, să efectueze reverse engineering, decompilare sau alte operațiuni similare, în măsura în care acestea nu sunt permise expres de lege.\n\nOrice utilizare a Aplicației sau a Conținutului Aplicației în afara limitelor acestei licențe este strict interzisă.'),
                _buildSubSection('7.3', 'Mărci și denumiri comerciale',
                    'Denumirea VladAI, logo-urile, elementele de branding și orice alte mărci sau semne distinctive utilizate în cadrul Aplicației sunt mărci sau mărci înregistrate aparținând Tech-Hub Horizon SRL.\n\nUtilizarea acestora fără acordul prealabil scris al Operatorului este strict interzisă. Orice beneficiu de imagine („goodwill") rezultat din utilizarea mărcii VladAI revine exclusiv titularului acesteia.'),
                _buildSubSection('7.4', 'Încălcarea drepturilor de proprietate intelectuală',
                    'Tech-Hub Horizon SRL respectă drepturile de proprietate intelectuală ale terților. În cazul în care consideri că un conținut disponibil prin Aplicația VladAI încalcă drepturile tale de proprietate intelectuală, ne poți transmite o notificare la adresa vladairomania@gmail.com, care să includă informații suficiente pentru identificarea conținutului și a dreptului pretins.\n\nOperatorul își rezervă dreptul de a investiga sesizările primite și de a lua măsurile considerate necesare, inclusiv eliminarea conținutului, restricționarea accesului sau suspendarea conturilor implicate, în conformitate cu legea.'),

                // Section 8
                _buildSectionTitle('8. Declarații, declinarea garanțiilor și limitarea răspunderii'),
                _buildSubSection('8.1', 'Furnizarea Aplicației „ca atare"',
                    'În măsura maximă permisă de legislația aplicabilă, Aplicația VladAI și Serviciile furnizate prin intermediul acesteia sunt oferite „ca atare" („as is") și „în funcție de disponibilitate" („as available"), fără garanții exprese sau implicite de niciun fel.\n\nTech-Hub Horizon SRL nu garantează că:\n• Aplicația va funcționa fără întreruperi, erori sau întârzieri;\n• informațiile, recomandările sau itinerariile generate vor fi complete, exacte, actualizate sau adecvate pentru un anumit scop;\n• Aplicația va fi compatibilă cu toate dispozitivele, sistemele de operare sau versiunile acestora;\n• eventualele erori sau deficiențe vor fi corectate într-un anumit interval de timp.'),
                _buildSubSection('8.2', 'Caracterul informativ al recomandărilor',
                    'Utilizatorul recunoaște și acceptă că informațiile, sugestiile și itinerariile furnizate de VladAI:\n• au caracter orientativ și informativ;\n• sunt generate pe baza datelor furnizate de utilizator și a informațiilor disponibile la momentul respectiv;\n• nu constituie consultanță profesională, garanții sau angajamente ferme.\n\nTech-Hub Horizon SRL nu își asumă răspunderea pentru deciziile luate de utilizator pe baza informațiilor sau recomandărilor generate prin intermediul Aplicației, inclusiv, dar fără a se limita la, decizii privind planificarea călătoriilor, programul vizitelor, bugete, rezervări sau alte aspecte similare.'),
                _buildSubSection('8.3', 'Servicii și informații furnizate de terți',
                    'Aplicația VladAI poate integra sau afișa informații furnizate de terți (de exemplu: servicii de cartografiere, locații, obiective turistice, restaurante, cazare, programe de funcționare, tarife sau alte date similare).\n\nTech-Hub Horizon SRL nu răspunde pentru:\n• exactitatea, completitudinea sau actualitatea informațiilor furnizate de terți;\n• modificarea, indisponibilitatea sau întreruperea serviciilor terțe;\n• eventualele prejudicii rezultate din utilizarea sau imposibilitatea utilizării serviciilor sau informațiilor furnizate de terți.\n\nRelația dintre utilizator și furnizorii terți este guvernată exclusiv de termenii și condițiile acestora.'),
                _buildSubSection('8.4', 'Limitarea răspunderii',
                    'În măsura permisă de lege, Tech-Hub Horizon SRL nu va fi răspunzătoare pentru:\n• erori, întreruperi, întârzieri, defecțiuni tehnice sau pierderi de date cauzate de factori externi, inclusiv, dar fără a se limita la, probleme de conexiune la internet, defecțiuni ale dispozitivului utilizatorului sau ale sistemelor terțe;\n• daune indirecte, accidentale, speciale sau consecutive, inclusiv pierderi de profit, pierderi de oportunități, pierderi comerciale sau alte prejudicii similare, chiar dacă Operatorul a fost informat despre posibilitatea producerii acestora.\n\nRăspunderea totală a Tech-Hub Horizon SRL, indiferent de temeiul juridic, este limitată, în măsura permisă de lege, la valoarea eventualelor sume plătite de utilizator pentru utilizarea Serviciilor, dacă este cazul.'),
                _buildSubSection('8.5', 'Drepturile consumatorilor',
                    'Nicio prevedere din acești Termeni nu are scopul de a exclude sau limita drepturile utilizatorilor în calitate de consumatori, în măsura în care legislația aplicabilă interzice astfel de limitări sau excluderi.'),

                // Section 9
                _buildSectionTitle('9. Suspendarea și încetarea accesului la Aplicație'),
                _buildSubSection('9.1', 'Suspendarea sau încetarea de către Operator',
                    'Tech-Hub Horizon SRL își rezervă dreptul, la libera sa apreciere și în limitele permise de lege, de a suspenda temporar sau de a înceta definitiv accesul unui utilizator la Aplicația VladAI și/sau de a închide contul de utilizator, cu sau fără notificare prealabilă, în oricare dintre următoarele situații, fără a se limita la acestea:\n• utilizatorul încalcă sau există indicii rezonabile că a încălcat prezentele Termeni și Condiții;\n• există suspiciuni rezonabile de fraudă, utilizare abuzivă, activități ilegale sau acces neautorizat la Aplicație ori la cont;\n• măsura este necesară pentru protejarea securității Aplicației, a infrastructurii tehnice, a datelor sau a altor utilizatori;\n• suspendarea sau încetarea este impusă de o obligație legală, o solicitare a autorităților competente sau pentru prevenirea unor riscuri juridice.\n\nÎn măsura permisă de lege, Tech-Hub Horizon SRL nu va fi obligată să motiveze decizia și nu va fi răspunzătoare pentru eventualele prejudicii rezultate din suspendarea sau încetarea accesului, cu excepția cazurilor în care legea prevede în mod expres contrariul.'),
                _buildSubSection('9.2', 'Efectele suspendării sau încetării',
                    'În cazul suspendării sau încetării accesului:\n• dreptul utilizatorului de a accesa și utiliza Aplicația încetează imediat;\n• contul de utilizator și accesul la funcționalități pot fi restricționate sau dezactivate;\n• Tech-Hub Horizon SRL poate șterge sau păstra anumite date asociate contului, în conformitate cu Politica de confidențialitate și obligațiile legale aplicabile.\n\nÎncetarea accesului nu afectează drepturile și obligațiile deja născute între părți și nici aplicabilitatea prevederilor care, prin natura lor, sunt destinate să supraviețuiască încetării (inclusiv, fără a se limita la, dispozițiile privind limitarea răspunderii, proprietatea intelectuală și legea aplicabilă).'),
                _buildSubSection('9.3', 'Încetarea la inițiativa utilizatorului',
                    'Utilizatorul poate solicita oricând încetarea utilizării Aplicației și ștergerea contului de utilizator, în conformitate cu procedura descrisă în Politica de confidențialitate. Solicitarea poate fi transmisă prin intermediul funcționalităților Aplicației sau prin email la vladairomania@gmail.com.'),

                // Section 10
                _buildSectionTitle('10. Modificarea Serviciilor și a Termenilor și Condițiilor'),
                _buildSubSection('10.1', 'Modificarea Serviciilor',
                    'Tech-Hub Horizon SRL își rezervă dreptul de a modifica, actualiza, extinde, restrânge, suspenda sau întrerupe, total sau parțial, funcționalitățile Aplicației VladAI și/sau Serviciile oferite, temporar sau permanent, în orice moment, din motive care pot include, fără a se limita la:\n• considerente tehnice sau operaționale;\n• motive de securitate;\n• modificări legislative sau de reglementare;\n• decizii comerciale sau strategice.\n\nÎn măsura permisă de lege, Tech-Hub Horizon SRL nu garantează disponibilitatea continuă sau neîntreruptă a tuturor funcționalităților Aplicației și nu poate fi trasă la răspundere pentru eventualele consecințe rezultate din modificarea, suspendarea sau întreruperea acestora.'),
                _buildSubSection('10.2', 'Modificarea Termenilor și Condițiilor',
                    'Ne rezervăm dreptul de a modifica sau actualiza prezentele Termeni și Condiții ori de câte ori este necesar, pentru a reflecta:\n• modificări ale Serviciilor;\n• schimbări legislative sau de reglementare;\n• actualizări ale practicilor noastre interne.\n\nVersiunea actualizată a Termenilor va fi publicată în cadrul Aplicației și va produce efecte de la data publicării, cu excepția cazului în care se specifică expres o altă dată de intrare în vigoare.\n\nContinuarea utilizării Aplicației VladAI după publicarea modificărilor constituie acceptarea expresă a Termenilor și Condițiilor astfel actualizați. În cazul în care nu ești de acord cu modificările aduse, singurul remediu este încetarea utilizării Aplicației și solicitarea ștergerii contului.'),

                // Section 11
                _buildSectionTitle('11. Legea aplicabilă și jurisdicția'),
                _buildParagraph(
                  'Prezentele Termeni și Condiții, precum și orice relație contractuală sau necontractuală dintre utilizator și Tech-Hub Horizon SRL, sunt guvernate și interpretate în conformitate cu legislația aplicabilă din România, cu respectarea dispozițiilor obligatorii ale dreptului Uniunii Europene.',
                ),
                _buildParagraph(
                  'Orice litigiu, dispută sau pretenție rezultată din sau în legătură cu utilizarea Aplicației VladAI, cu Serviciile oferite sau cu prezentele Termeni și Condiții va fi soluționată, pe cât posibil, pe cale amiabilă.',
                ),
                _buildParagraph(
                  'În cazul în care soluționarea amiabilă nu este posibilă, instanțele judecătorești competente din România vor avea jurisdicție exclusivă pentru soluționarea oricăror astfel de litigii, cu excepția situațiilor în care legislația aplicabilă în materie de protecție a consumatorilor prevede dreptul utilizatorului de a sesiza instanțele competente din statul său de domiciliu sau reședință.',
                ),
                _buildParagraph(
                  'Nicio prevedere din prezenta secțiune nu aduce atingere drepturilor de care beneficiază consumatorii în temeiul legislației obligatorii aplicabile în Uniunea Europeană.',
                ),

                // Section 12
                _buildSectionTitle('12. Contact și dispoziții finale'),
                _buildSubSection('12.1', 'Contact',
                    'Pentru orice întrebări, solicitări, sesizări sau clarificări referitoare la prezentele Termeni și Condiții, la utilizarea Aplicației VladAI sau la Serviciile oferite, utilizatorii pot contacta operatorul folosind următoarele date:\n\nOperator: Tech-Hub Horizon SRL\nSediu: Borșa, județul Maramureș, Str. Negoiului nr. 2C, România\nEmail: vladairomania@gmail.com\n\nVom depune eforturi rezonabile pentru a analiza și a răspunde solicitărilor primite într-un termen adecvat, în conformitate cu obligațiile legale aplicabile.'),
                _buildSubSection('12.2', 'Dispoziții finale',
                    'În cazul în care oricare dintre prevederile prezentelor Termeni și Condiții este sau devine nulă, nevalidă sau inaplicabilă, total sau parțial, conform unei hotărâri definitive a unei instanțe competente, aceasta nu va afecta valabilitatea și aplicabilitatea celorlalte prevederi, care vor rămâne în vigoare și vor produce efecte juridice.\n\nNeexercitarea sau exercitarea cu întârziere de către Tech-Hub Horizon SRL a oricărui drept prevăzut în acești Termeni nu constituie o renunțare la respectivul drept.\n\nPrezentele Termeni și Condiții, împreună cu Politica de confidențialitate și orice alte politici sau documente la care se face trimitere expres, constituie întregul acord dintre utilizator și Tech-Hub Horizon SRL cu privire la utilizarea Aplicației VladAI și înlocuiesc orice înțelegeri sau acorduri anterioare, scrise sau verbale, referitoare la același obiect.'),

                50.verticalSpace,
              ],
            ).paddingHorizontal(20.sp).paddingTop(20.h),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 12.h),
      child: Text(
        title,
        style: AppTextStyles.customText16(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubSection(String number, String subtitle, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number $subtitle',
            style: AppTextStyles.customText14(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          8.verticalSpace,
          Text(
            content,
            style: AppTextStyles.customText14(
              color: AppColors.black.withOpacity(0.8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedSection(String number, String subtitle, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. $subtitle',
            style: AppTextStyles.customText14(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          8.verticalSpace,
          Text(
            content,
            style: AppTextStyles.customText14(
              color: AppColors.black.withOpacity(0.8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParagraph(String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        content,
        style: AppTextStyles.customText14(
          color: AppColors.black.withOpacity(0.8),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
