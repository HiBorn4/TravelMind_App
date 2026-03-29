import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlad_ai/app/config/app_text_style.dart';
import 'package:vlad_ai/app/config/padding_extensions.dart';
import 'package:vlad_ai/l10n/l10n.dart';

import '../../../config/app_assets.dart';
import '../../../config/app_colors.dart';
import '../../../customWidgets/custom_app_bar.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        toolBarHeight: 70.h,
        title: context.l10n!.privacy_policy,
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
                _buildSectionTitle('Tech-Hub Horizon SRL'),
                _buildParagraph(
                  'VladAI este o aplicație turistică operată de Tech-Hub Horizon SRL - CUI 46003331, societate înregistrată în România, care oferă utilizatorilor acces la informații, recomandări și itinerarii de călătorie personalizate, generate prin intermediul unor tehnologii digitale și sisteme automatizate.',
                ),
                _buildParagraph(
                  'Atunci când utilizați serviciul, interacționați cu un sistem conversațional bazat pe inteligență artificială, și nu cu un operator uman. Această informare este furnizată în scopul respectării obligațiilor de transparență, inclusiv a celor prevăzute de Regulamentul privind inteligența artificială al Uniunii Europene (EU AI Act).',
                ),
                _buildParagraph(
                  'Prezenta Politică de confidențialitate are scopul de a explica, într-un mod transparent și conform legislației aplicabile, ce categorii de date cu caracter personal sunt colectate prin intermediul aplicației VladAI, în ce scopuri sunt acestea prelucrate, cum sunt protejate și care sunt drepturile de care beneficiază utilizatorii în legătură cu datele lor.',
                ),
                16.verticalSpace,
                _buildImportantBox(
                  'VĂ RUGĂM SĂ CITIȚI CU ATENȚIE ÎNAINTE DE A CONTINUA SĂ ACCESAȚI APLICAȚIA SAU SĂ UTILIZAȚI SERVICIILE NOASTRE. Prin accesarea aplicației și/sau utilizarea serviciilor noastre, confirmați că ați citit, ați înțeles și sunteți de acord să respectați prezenta Politică de confidențialitate, precum și Termenii și Condițiile aplicabile.\n\nDacă nu sunteți de acord cu prevederile acestei Politici de confidențialitate, nu aveți dreptul să accesați, să utilizați sau să continuați utilizarea serviciilor noastre.\n\nÎn cazul în care utilizați serviciile în numele altei persoane, declarați și garantați că sunteți autorizat(ă) de respectiva persoană să acceptați această Politică de confidențialitate în numele său și că acceptați prezenta Politică de confidențialitate în numele acesteia.',
                ),

                // Section 1
                _buildSectionTitle('1. Ce date cu caracter personal colectăm'),
                _buildParagraph(
                  'În cadrul utilizării aplicației VladAI, putem colecta și prelucra anumite categorii de date cu caracter personal, în funcție de modul în care utilizatorul interacționează cu aplicația și de funcționalitățile utilizate. Colectarea și prelucrarea datelor se realizează exclusiv în scopuri legitime, determinate și explicite, în conformitate cu legislația aplicabilă privind protecția datelor cu caracter personal.',
                ),

                _buildSubSectionTitle('1.1 Date furnizate direct de utilizator'),
                _buildParagraph(
                  'La crearea unui cont de utilizator în aplicația VladAI, solicităm și colectăm date de identificare și contact necesare pentru administrarea contului și furnizarea serviciilor oferite prin aplicație. Aceste date pot include:',
                ),
                _buildBulletPoint('numele și prenumele;'),
                _buildBulletPoint('adresa de email;'),
                _buildBulletPoint('numărul de telefon;'),
                _buildBulletPoint('informații privind locația generală, respectiv țara și orașul din care utilizatorul accesează aplicația.'),
                _buildParagraph(
                  'Furnizarea acestor date este necesară pentru crearea și gestionarea contului de utilizator, pentru comunicarea cu utilizatorul și pentru personalizarea serviciilor oferite prin aplicație. Nefurnizarea anumitor date poate conduce la imposibilitatea utilizării unor funcționalități ale aplicației.',
                ),

                _buildSubSectionTitle('1.2 Date legate de utilizarea aplicației'),
                _buildParagraph(
                  'Pentru a furniza funcționalitățile esențiale ale aplicației VladAI, este necesară colectarea și stocarea anumitor date generate ca urmare a utilizării aplicației. În mod particular, aplicația se bazează pe salvarea în baza noastră de date a itinerariilor create de utilizator și a informațiilor aferente acestora. În lipsa acestei stocări, funcționarea corectă a aplicației ar fi imposibilă, iar serviciile de bază (inclusiv generarea, afișarea, gestionarea și regăsirea itinerariilor) nu ar putea fi oferite.',
                ),
                _buildParagraph(
                  'Ca urmare, pe parcursul utilizării aplicației, putem colecta și prelucra următoarele categorii de date, fără a ne limita la acestea:',
                ),
                _buildBulletPoint('itinerariile de călătorie create de utilizator (inclusiv structura pe zile/ore, locațiile incluse și opțiuni selectate);'),
                _buildBulletPoint('preferințe de călătorie, interese și criterii introduse în formular (de exemplu: tip de activități preferate, ritm de vizitare, durata călătoriei, intervale orare, alte opțiuni relevante);'),
                _buildBulletPoint('informații și conținut furnizate de utilizator în cadrul formularelor sau funcționalităților din aplicație, în măsura în care acestea sunt necesare pentru generarea itinerariilor și furnizarea serviciului.'),
                _buildParagraph('Aceste date sunt prelucrate în principal pentru:'),
                _buildBulletPoint('generarea și livrarea itinerariilor personalizate solicitate de utilizator;'),
                _buildBulletPoint('salvarea itinerariilor astfel încât utilizatorul să le poată accesa ulterior, revizui, utiliza, sau modifica;'),
                _buildBulletPoint('asigurarea continuității serviciului (de exemplu, atunci când utilizatorul reinstalează aplicația, schimbă dispozitivul sau se autentifică din nou);'),
                _buildBulletPoint('prevenirea erorilor, diagnosticarea problemelor și îmbunătățirea funcționalităților aplicației.'),
                _buildParagraph(
                  'Acceptarea acestei prelucrări este o condiție necesară pentru utilizarea aplicației VladAI. În cazul în care un utilizator nu este de acord cu colectarea și stocarea acestor date în baza noastră de date, acesta nu va putea utiliza aplicația, întrucât funcționalitățile principale depind în mod direct de această prelucrare.',
                ),

                _buildSubSectionTitle('1.3 Date colectate automat'),
                _buildParagraph(
                  'Atunci când utilizezi aplicația VladAI, anumite informații pot fi colectate automat prin intermediul tehnologiilor de analiză și monitorizare a utilizării aplicației. Aceste informații pot include:',
                ),
                _buildBulletPoint('tipul dispozitivului utilizat (telefon mobil, tabletă etc.);'),
                _buildBulletPoint('sistemul de operare și versiunea acestuia;'),
                _buildBulletPoint('informații privind modul de interacțiune cu aplicația, cum ar fi paginile sau ecranele accesate, durata sesiunilor și frecvența utilizării;'),
                _buildBulletPoint('informații privind locația aproximativă a utilizatorului, determinate la nivel de oraș sau țară.'),
                _buildParagraph(
                  'Aceste date sunt utilizate în scopuri statistice, de analiză și optimizare a performanței aplicației și nu permit, în mod direct, identificarea precisă a utilizatorului.',
                ),

                // Section 2
                _buildSectionTitle('2. Chatbot și sisteme automate (inteligență artificială)'),
                _buildParagraph(
                  'Aplicația VladAI utilizează sisteme automate bazate pe inteligență artificială („AI") pentru a furniza utilizatorilor recomandări turistice, sugestii de itinerarii și alte informații personalizate, în funcție de datele și preferințele furnizate de utilizator.',
                ),
                _buildParagraph(
                  'Prin utilizarea funcționalităților de tip chatbot, utilizatorul este informat și recunoaște în mod expres faptul că interacționează exclusiv cu un sistem automatizat, iar nu cu un operator uman. Răspunsurile și itinerariile generate sunt rezultatul unor procese automate de analiză și prelucrare a datelor introduse în aplicație.',
                ),

                _buildSubSectionTitle('2.1 Prelucrarea datelor în cadrul sistemelor AI'),
                _buildParagraph('În cadrul interacțiunilor cu sistemele AI ale aplicației VladAI:'),
                _buildBulletPoint('mesajele, solicitările și informațiile introduse de utilizator pot fi prelucrate automat pentru a genera răspunsuri, recomandări și itinerarii;'),
                _buildBulletPoint('anumite date pot fi stocate ca parte a istoricului de utilizare, exclusiv în scopul furnizării serviciului, al îmbunătățirii funcționalităților aplicației și al asigurării continuității experienței utilizatorului;'),
                _buildBulletPoint('prelucrarea are loc în conformitate cu scopurile declarate în prezenta Politică de confidențialitate și cu respectarea cerințelor legale aplicabile.'),
                _buildParagraph(
                  'Aplicația VladAI nu utilizează aceste date pentru a lua decizii cu efecte juridice asupra utilizatorului și nu produce efecte similare semnificative din punct de vedere legal.',
                ),

                _buildSubSectionTitle('2.2 Limitări și responsabilitatea utilizatorului'),
                _buildParagraph('Deși sistemele AI sunt concepute pentru a oferi informații relevante și utile, rezultatele generate:'),
                _buildBulletPoint('au caracter orientativ și informativ;'),
                _buildBulletPoint('nu constituie garanții privind exactitatea, completitudinea sau actualitatea informațiilor;'),
                _buildBulletPoint('pot fi influențate de datele introduse de utilizator și de disponibilitatea informațiilor.'),
                _buildParagraph(
                  'Utilizatorul este responsabil pentru modul în care utilizează informațiile furnizate de aplicație și este încurajat să verifice informațiile esențiale (de exemplu, programul obiectivelor, condiții de acces, disponibilitate).',
                ),

                _buildSubSectionTitle('2.3 Date sensibile'),
                _buildParagraph('Aplicația VladAI nu este concepută pentru colectarea sau prelucrarea datelor cu caracter sensibil, precum:'),
                _buildBulletPoint('date medicale;'),
                _buildBulletPoint('informații financiare sau bancare;'),
                _buildBulletPoint('parole;'),
                _buildBulletPoint('date de identificare oficială (CNP, serie CI, pașaport etc.).'),
                _buildParagraph(
                  'Utilizatorul este rugat să nu introducă astfel de informații în cadrul chatbotului, formularelor sau oricăror alte funcționalități ale aplicației. În măsura în care utilizatorul furnizează voluntar asemenea date, VladAI nu își asumă responsabilitatea pentru consecințele rezultate din introducerea acestora, iar respectivele date pot fi procesate sau stocate ca parte a interacțiunii, în limitele permise de lege.',
                ),

                // Section 3
                _buildSectionTitle('3. Cum folosim datele cu caracter personal'),
                _buildParagraph(
                  'Datele cu caracter personal colectate prin intermediul aplicației VladAI sunt prelucrate exclusiv în scopuri determinate, explicite și legitime, în conformitate cu legislația aplicabilă privind protecția datelor cu caracter personal, inclusiv Regulamentul (UE) 2016/679 (GDPR).',
                ),
                _buildParagraph('În mod specific, utilizăm datele cu caracter personal pentru următoarele scopuri:'),
                _buildBulletPoint('crearea, administrarea și gestionarea contului de utilizator, inclusiv autentificarea, comunicarea cu utilizatorul și asigurarea funcționării continue a contului;'),
                _buildBulletPoint('generarea, salvarea și gestionarea itinerariilor de călătorie, precum și furnizarea de recomandări personalizate, în funcție de datele și preferințele furnizate de utilizator;'),
                _buildBulletPoint('asigurarea funcționalităților aplicației, inclusiv operarea tehnică, mentenanța, remedierea erorilor și prevenirea utilizărilor neautorizate sau abuzive;'),
                _buildBulletPoint('îmbunătățirea experienței utilizatorilor, prin analizarea modului în care aplicația este utilizată și prin optimizarea funcționalităților, conținutului și interfeței;'),
                _buildBulletPoint('analizarea utilizării aplicației, în scopuri statistice și de performanță, inclusiv prin intermediul instrumentelor de analiză, fără a urmări identificarea directă a utilizatorilor;'),
                _buildBulletPoint('îndeplinirea obligațiilor legale și de reglementare, precum și protejarea drepturilor, intereselor și securității operatorului și ale utilizatorilor.'),
                _buildParagraph(
                  'Prelucrarea datelor se realizează în temeiul executării contractului dintre utilizator și operator (respectiv furnizarea serviciilor prin aplicație), al interesului legitim al operatorului de a asigura funcționarea și îmbunătățirea aplicației, precum și, acolo unde este cazul, al respectării obligațiilor legale.',
                ),
                _buildParagraph(
                  'Nu utilizăm datele cu caracter personal în scopuri ilegale și nu vindem datele personale ale utilizatorilor către terți. Datele pot fi divulgate exclusiv în condițiile prevăzute în prezenta Politică de confidențialitate și în conformitate cu legea.',
                ),

                // Section 4
                _buildSectionTitle('4. Servicii terțe utilizate'),
                _buildParagraph(
                  'Pentru asigurarea funcționării tehnice a aplicației VladAI și pentru îmbunătățirea performanței și a experienței utilizatorilor, utilizăm anumite servicii furnizate de terți. Aceste servicii pot implica prelucrarea unor date cu caracter personal sau a unor date tehnice, în măsura necesară furnizării funcționalităților respective.',
                ),
                _buildParagraph(
                  'Utilizarea serviciilor terțe se realizează în baza unor relații contractuale care impun furnizorilor respectarea obligațiilor legale privind protecția datelor cu caracter personal, în conformitate cu legislația aplicabilă.',
                ),

                _buildSubSectionTitle('4.1 Mapbox'),
                _buildParagraph(
                  'Aplicația VladAI utilizează serviciile Mapbox exclusiv pentru afișarea hărților și a elementelor cartografice necesare vizualizării locațiilor și itinerariilor generate în cadrul aplicației.',
                ),
                _buildParagraph(
                  'Mapbox poate prelucra anumite date tehnice strict necesare funcționării serviciilor de cartografiere (de exemplu, solicitări de afișare a hărților, parametri tehnici ai aplicației sau ai dispozitivului), fără ca aplicația VladAI să transmită către Mapbox date de localizare ale utilizatorului și fără a urmări identificarea directă a acestuia.',
                ),
                _buildParagraph(
                  'Prelucrarea eventualelor date de către Mapbox se realizează în conformitate cu politica de confidențialitate și condițiile proprii ale Mapbox. VladAI nu controlează modul în care Mapbox prelucrează datele în nume propriu și recomandă utilizatorilor să consulte documentația și politica de confidențialitate a Mapbox pentru informații suplimentare.',
                ),

                _buildSubSectionTitle('4.2 Google Analytics'),
                _buildParagraph(
                  'Aplicația VladAI utilizează Google Analytics, un serviciu de analiză furnizat de Google, pentru a colecta informații privind modul în care utilizatorii interacționează cu aplicația.',
                ),
                _buildParagraph('Datele colectate prin intermediul Google Analytics pot include informații precum:'),
                _buildBulletPoint('tipul dispozitivului;'),
                _buildBulletPoint('sistemul de operare;'),
                _buildBulletPoint('evenimente și interacțiuni în aplicație;'),
                _buildBulletPoint('durata sesiunilor și frecvența utilizării.'),
                _buildParagraph(
                  'Aceste date sunt utilizate exclusiv în scopuri statistice, de analiză și optimizare a funcționalităților aplicației, fără a urmări identificarea directă a utilizatorilor. Prelucrarea datelor de către Google se realizează în conformitate cu politica de confidențialitate și condițiile aplicabile ale Google.',
                ),

                // Section 5
                _buildSectionTitle('5. Cookie-uri și tehnologii similare'),
                _buildParagraph(
                  'Aplicația VladAI, în calitate de aplicație mobilă, nu utilizează cookie-uri în sensul clasic specific site-urilor web. Cu toate acestea, aplicația poate utiliza tehnologii echivalente cookie-urilor, precum SDK-uri, identificatori de aplicație și alte tehnologii similare, necesare pentru funcționarea tehnică, analiza utilizării și îmbunătățirea performanței aplicației.',
                ),
                _buildParagraph('Aceste tehnologii pot fi utilizate în următoarele scopuri:'),
                _buildBulletPoint('analiză, pentru a înțelege modul în care utilizatorii interacționează cu aplicația;'),
                _buildBulletPoint('funcționalitate, pentru a asigura operarea corectă a aplicației și a funcțiilor sale esențiale;'),
                _buildBulletPoint('optimizarea performanței, pentru identificarea erorilor și îmbunătățirea stabilității și experienței de utilizare.'),
                _buildParagraph(
                  'Tehnologiile menționate pot fi furnizate direct de VladAI sau prin intermediul serviciilor terțe utilizate (de exemplu, servicii de analiză), în conformitate cu politicile acestora de confidențialitate.',
                ),

                // Section 6
                _buildSectionTitle('6. Cui divulgăm datele cu caracter personal'),
                _buildParagraph(
                  'VladAI tratează datele cu caracter personal ale utilizatorilor cu maximă responsabilitate. Datele colectate prin intermediul aplicației rămân în posesia și sub controlul exclusiv al operatorului, respectiv Tech-Hub Horizon SRL, și nu sunt vândute, închiriate sau transferate către terți în scopuri comerciale.',
                ),
                _buildParagraph(
                  'Nu divulgăm datele cu caracter personal ale utilizatorilor către terți, cu excepția situațiilor strict limitate și impuse de lege.',
                ),
                _buildParagraph('În mod specific, datele cu caracter personal pot fi divulgate exclusiv în următoarele cazuri:'),
                _buildBulletPoint('autorităților publice, instanțelor de judecată sau altor organisme competente, în măsura în care divulgarea este impusă de o obligație legală, de un ordin judecătoresc sau de o solicitare legală formulată în conformitate cu legislația aplicabilă.'),
                _buildParagraph(
                  'În toate celelalte situații, datele cu caracter personal nu sunt divulgate către terți și sunt utilizate doar în scopurile descrise în prezenta Politică de confidențialitate.',
                ),
                _buildParagraph(
                  'Nu divulgăm și nu utilizăm datele utilizatorilor în scopuri comerciale neautorizate și nu permitem accesul unor terți la datele personale, în afara cazurilor prevăzute expres de lege.',
                ),

                // Section 7
                _buildSectionTitle('7. Păstrarea datelor (perioada de stocare)'),
                _buildParagraph(
                  'Tech-Hub Horizon SRL păstrează datele cu caracter personal ale utilizatorilor VladAI numai pe perioada necesară îndeplinirii scopurilor pentru care acestea au fost colectate și prelucrate, cu respectarea principiului limitării stocării prevăzut de legislația aplicabilă.',
                ),
                _buildParagraph('În mod uzual, datele pot fi păstrate:'),
                _buildBulletPoint('pe durata existenței contului de utilizator, respectiv atât timp cât contul este activ;'),
                _buildBulletPoint('pe durata necesară furnizării serviciilor esențiale ale aplicației, inclusiv pentru a permite utilizatorului accesul ulterior la itinerariile salvate și la funcționalitățile asociate;'),
                _buildBulletPoint('pe perioada necesară îndeplinirii obligațiilor legale aplicabile, acolo unde legislația impune păstrarea anumitor evidențe sau informații.'),

                _buildSubSectionTitle('Ștergerea contului și a datelor'),
                _buildParagraph(
                  'Utilizatorul poate solicita oricând ștergerea contului și a datelor asociate acestuia, prin transmiterea unei solicitări la adresa de email: vladairomania@gmail.com sau direct din aplicatie.',
                ),
                _buildParagraph(
                  'În urma unei solicitări valide de ștergere, vom lua măsuri pentru a elimina datele din sistemele active, într-un termen rezonabil, cu excepția situațiilor în care păstrarea anumitor date este necesară:',
                ),
                _buildBulletPoint('pentru respectarea unei obligații legale;'),
                _buildBulletPoint('pentru exercitarea sau apărarea unor drepturi în instanță;'),
                _buildBulletPoint('pentru prevenirea fraudelor, securitatea sistemelor și investigarea unor utilizări abuzive.'),
                _buildParagraph(
                  'În astfel de cazuri, datele vor fi păstrate strict în măsura și pe durata necesară îndeplinirii acestor scopuri, în conformitate cu legea.',
                ),

                // Section 8
                _buildSectionTitle('8. Drepturile utilizatorilor conform GDPR'),
                _buildParagraph(
                  'În conformitate cu Regulamentul (UE) 2016/679 privind protecția datelor cu caracter personal („GDPR"), utilizatorii aplicației VladAI beneficiază de o serie de drepturi în legătură cu prelucrarea datelor lor cu caracter personal.',
                ),
                _buildParagraph('În măsura în care sunt îndeplinite condițiile prevăzute de lege, utilizatorul are următoarele drepturi:'),
                _buildBulletPoint('dreptul de acces, respectiv dreptul de a obține confirmarea faptului că datele sale cu caracter personal sunt sau nu prelucrate și, dacă este cazul, acces la aceste date;'),
                _buildBulletPoint('dreptul la rectificare, respectiv dreptul de a solicita corectarea sau completarea datelor cu caracter personal inexacte sau incomplete;'),
                _buildBulletPoint('dreptul la ștergere („dreptul de a fi uitat"), respectiv dreptul de a solicita ștergerea datelor cu caracter personal, în condițiile prevăzute de GDPR;'),
                _buildBulletPoint('dreptul la restricționarea prelucrării, respectiv dreptul de a solicita limitarea prelucrării datelor în anumite situații prevăzute de lege;'),
                _buildBulletPoint('dreptul de opoziție, respectiv dreptul de a se opune prelucrării datelor cu caracter personal, în condițiile stabilite de GDPR;'),
                _buildBulletPoint('dreptul la portabilitatea datelor, respectiv dreptul de a primi datele cu caracter personal furnizate într-un format structurat, utilizat în mod curent și care poate fi citit automat, sau de a solicita transmiterea acestora către un alt operator, acolo unde este aplicabil.'),
                _buildParagraph(
                  'Pentru exercitarea oricăruia dintre drepturile menționate mai sus, utilizatorul poate transmite o solicitare la adresa de email: vladairomania@gmail.com.',
                ),
                _buildParagraph(
                  'Vom analiza și soluționa solicitările primite în termenul legal prevăzut de GDPR, cu posibilitatea prelungirii acestuia în cazurile permise de lege, situație în care utilizatorul va fi informat corespunzător.',
                ),

                // Section 9
                _buildSectionTitle('9. Utilizarea aplicației de către minori'),
                _buildParagraph(
                  'Aplicația VladAI nu este destinată utilizării de către persoane care nu au împlinit vârsta de 18 ani. Nu colectăm și nu prelucrăm cu bună știință date cu caracter personal aparținând minorilor.',
                ),
                _buildParagraph(
                  'În situația în care avem motive rezonabile să credem că date cu caracter personal ale unui minor au fost colectate sau prelucrate prin intermediul aplicației, vom lua măsurile necesare pentru ștergerea acestor date în cel mai scurt timp posibil.',
                ),
                _buildParagraph(
                  'Dacă ești părinte sau reprezentant legal și consideri că un minor ne-a furnizat date cu caracter personal, te rugăm să ne contactezi la adresa de email: vladairomania@gmail.com.',
                ),

                // Section 10
                _buildSectionTitle('10. Securitatea datelor'),
                _buildParagraph(
                  'Tech-Hub Horizon SRL implementează măsuri tehnice și organizatorice adecvate pentru a proteja datele cu caracter personal împotriva accesului neautorizat, divulgării, modificării sau distrugerii acestora. Aceste măsuri sunt concepute având în vedere natura datelor prelucrate, riscurile asociate prelucrării și stadiul actual al tehnologiei.',
                ),
                _buildParagraph(
                  'Măsurile de securitate adoptate pot include, fără a se limita la acestea, controale de acces, proceduri interne de securitate, mecanisme de protecție a infrastructurii și alte măsuri menite să asigure un nivel de securitate corespunzător riscurilor identificate.',
                ),
                _buildParagraph(
                  'Cu toate acestea, utilizatorul ia act de faptul că niciun sistem de transmitere sau stocare a datelor nu poate fi garantat ca fiind complet sigur. În consecință, deși depunem eforturi rezonabile pentru protejarea datelor cu caracter personal, nu putem garanta securitatea absolută a acestora. Utilizarea aplicației și transmiterea datelor se realizează pe propria răspundere a utilizatorului, în limitele permise de legislația aplicabilă.',
                ),

                // Section 11
                _buildSectionTitle('11. Modificări ale Politicii de confidențialitate'),
                _buildParagraph(
                  'Ne rezervăm dreptul de a modifica și actualiza prezenta Politică de confidențialitate ori de câte ori este necesar, pentru a reflecta modificări ale funcționalităților aplicației VladAI, ale cerințelor legale sau ale practicilor noastre privind protecția datelor.',
                ),
                _buildParagraph(
                  'Orice modificare va fi publicată în cadrul aplicației și va intra în vigoare de la data afișării versiunii actualizate. Data ultimei actualizări va fi indicată în mod expres la începutul documentului.',
                ),
                _buildParagraph(
                  'În cazul în care modificările aduse sunt semnificative și afectează în mod substanțial modul în care sunt prelucrate datele cu caracter personal, vom depune eforturi rezonabile pentru a informa utilizatorii prin mijloace adecvate, în conformitate cu legislația aplicabilă.',
                ),
                _buildParagraph(
                  'Continuarea utilizării aplicației VladAI după publicarea modificărilor constituie acceptarea Politicii de confidențialitate astfel actualizate.',
                ),

                // Contact Section
                _buildSectionTitle('Contact'),
                _buildParagraph(
                  'Pentru orice întrebări, solicitări sau nelămuriri legate de prezenta Politică de confidențialitate sau de modul în care sunt prelucrate datele cu caracter personal prin intermediul aplicației VladAI, ne poți contacta folosind următoarele date:',
                ),
                _buildContactInfo('Operator:', 'Tech-Hub Horizon SRL'),
                _buildContactInfo('Adresă:', 'Borșa, județul Maramureș, Str. Negoiului nr. 2C, România'),
                _buildContactInfo('Email:', 'vladairomania@gmail.com'),
                12.verticalSpace,
                _buildParagraph(
                  'Vom analiza și răspunde solicitărilor primite într-un termen rezonabil și în conformitate cu obligațiile legale aplicabile.',
                ),

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
      padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
      child: Text(
        title,
        style: AppTextStyles.customText16(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
      child: Text(
        title,
        style: AppTextStyles.customText14(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
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

  Widget _buildBulletPoint(String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AppTextStyles.customText14(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: AppTextStyles.customText14(
                color: AppColors.black.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantBox(String content) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Text(
        content,
        style: AppTextStyles.customText14(
          color: AppColors.black.withOpacity(0.9),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContactInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: AppTextStyles.customText14(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.customText14(
                color: AppColors.black.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
