# Onderzoeksvraag

How can I create an endless runner game with Flutter and AR in </br>
combination with AI to generate real-time obstacles?</br>

# InstallatieHandleiding</br>

Om dit project te kunnen runnen dient u een telefoon te bezitten die ARCore ondersteunt. Om</br>
te controleren of uw telefoon dit ondersteunt kunt u kijken in deze lijst:</br>
https://developers.google.com/ar/devices. Staat de telefoon in de lijst? Dan kunt u deze</br>
gebruiken.</br>

1. Om een Flutter project te kunnen runne dient u eerst Flutter te installeren. Dit kunt u doen</br>
   door de stappen te volgen op volgende link: https://docs.flutter.dev/get-started/install. Op</br>
   deze site wordt stap per stap uitgelegd hoe u Flutter dient te installeren.</br>
2. a) Download de voorziene code (ingediend op Leho).</br>
   b) Download the code van GitHub: https://github.com/sarabluekens/researchProject</br>
   Let op: indien u code van github download, moet u nog 2 extra stappen uitvoeren. Namelijk bij</br>
   het runnen van de code zult u volgende error krijgen:</br>
   “The Android Gradle plugin supports only Kotlin Gradle plugin version 1.5.20 and higher.”</br>
   Om deze fout op te lossen dient u het project te open in Android Studio. In Android studio</br>
   navigeert u naar External Libraries>Flutter plugins>ar_flutter_plugin>android>build.gradle. In</br>
   deze build.gradle verandert u in buildscript ext.kotlin_version = '1.3.50' naar ext.kotlin_version =</br>
   '1.5.20'.</br>
   De tweede aanpassing die u dient te maken is de volgende: navigeer in het project naar de</br>
   lib file. Daar voeg je een file toe genaamd: api_key.dart. In die file plakt u volgende code:</br>
   const MyDalleKey = "uw_OpenAI_Secret_key ";</br>
   Om deze key te verkregen dient u op OpenAI Api een billing in te stellen, deze service is</br>
   namenlijk niet gratis. De billing instellen kunt u doen via deze link:</br>
   https://platform.openai.com/account/billing/overview</br>
   Eens dat u een billing heeft ingesteld en wat credit heeft geupload, kunt u een secret key</br>
   genereren. Dit doet u op volgende link: https://platform.openai.com/api-keys</br>
   Dit is de key die u in api_key.dart dient te plaatsen.</br>
3. Om dit project te runnen dient u uw telefoon met een USB-kabel te verbinden aan de laptop</br>
   waarop het project zal runnen. Indien u op uw telefoon een melding krijgt Op uw telefoon gaat</br>
   u naar “instellingen”, “info telefoon”, “softwaregegevens”. Op deze pagina klikt u 7 keer op</br>
   buildnummer. Daarna zal de melding u bent nu ontwikkerlaar kort verschijnen. Wanneer u nu</br>
   terugkeert naar instellingen, ziet u onder info telefoon en extra pagina ontwikkelaarsopties</br>
   staan. Klik op die pagina. In de ontwikkelaarsopties zet je USB-foutopsporing aan. Indien er</br>
   opnieuw een pop-up verschijnt, klikt u opnieuw op toestaan.</br>
4. In uw gekozen IDE (voor deze uitleg kies ik Visual Studio Code), navigeert u naar plugins en</br>
   daar installeert u volgende plugins: “Flutter”, “Dart”.</br>
5. In uw gekozen IDE gaat u naar de Command Palette en typt u Flutter: Select Device. Dan zou u</br>
   een lijst moeten zien met een drietal devices, waaronder uw aangesloten telefoon. Indien dit</br>
   niet het geval is gaat naar deze link: https://developer.android.com/studio/run/device.</br>
6. a) Wanneer u nu naar de main.dart navigeert in de lib map, zult u boven “void main” de knop</br>
   “Run” zien staan. Daar klikt u op.</br>
   b) Wanneer u naar de main.dart navigeert in de lib map, zult u Rechts van boven volgend</br>
   icoontje zien. Klik hierop om het project te starten.</br>
