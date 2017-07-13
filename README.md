# swift-style-guide
Guida di riferimento per i progetti Swift gestiti da Tiknil e i suoi collaboratori.

L'obiettivo è darsi delle **best practices** sulla stesura del codice per agevolare il lavoro in team e velocizzare la comprensione del codice.

## Riferimenti
Linee guida da cui è stato preso spunto per scrivere questo documento:
* [RayWenderlich Swift style guide](https://github.com/raywenderlich/swift-style-guide)
* [Swift guidelines](https://swift.org/documentation/api-design-guidelines/)

In generale **Tiknil adotta tutte le linee guida di RayWenderlich** e in questo documento riportiamo quelle che consideriamo più importanti ed eventuali modifiche o integrazioni ad esse.

## Sommario
* [Naming](#naming)
  * [Lingua](#lingua)
  * [Case conventions](#case-conventions)
  * [Type inferred context](#type-inferred-context)
* [Organizzazione del codice](#organizzazione-del-codice)
  * [Implementazione di protocolli](#implementazione-di-protocolli)
  * [Codice inutilizzato](#codice-inutilizzato)
* [Indentazione](#indentazione)
* [Design pattern](#design-pattern)
  * [MVC](#mvc)
  * [MVVM](#mvvm)
* [Struttura del progetto](#struttura-del-progetto)
  * [Repository e CocoaPods](#repository-e-cocoapods)
  * [Cartelle di progetto](#cartelle-di-progetto)

## Naming
Per facilitare la lettura del codice seguiamo i soprattutto i seguenti principi:
* chiarezza **>** brevità
* usare `CamelCase`, mai `snake_case`
* preferire metodi e proprietà a funzioni
* evitare overload di metodi modificando solo il tipo ritornato

### Lingua
Usare la lingua Inglese per il codice, quella Italiana per i commenti e la documentazione del codice (ove non espressamente richiesta la lingua inglese)

👍
```Swift
let myColor = UIColor.white
```

👎
```Swift
let mioColore = UIColor.white
```

### Case conventions
Tipi (classi) e protocolli in `UpperCamelCase`

Qualsiasi altra cosa in `LowerCamelCase`

👍
```Swift
class MyAwesomeClass { ... }
struct MyAwesomStruct { ... }
let constant = "http://www.tiknil.com"
var variable = 3
```

👎
```Swift
class myAwesomeClass { ... }
struct my_awesom_struct { ... }
let _constant = "http://www.tiknil.com"
var Variable = 3
```

### Type inferred context
Ove possibile lasciare contestualizzare al compilatore per migliorare la leggibilità del codice.

👍
```Swift
let selector = #selector(viewDidLoad)
view.backgroundColor = .red
let toView = context.view(forKey: .to)
let view = UIView(frame: .zero)
```

👎
```Swift
let selector = #selector(ViewController.viewDidLoad)
view.backgroundColor = UIColor.red
let toView = context.view(forKey: UITransitionContextViewKey.to)
let view = UIView(frame: CGRect.zero)
```

## Organizzazione del codice
Nelle classi utilizzare lo [snippet di codice] per la generazione dei `MARK` in modo da separare uniformemente il codice in tutte le classi secondo la seguente struttura:

```Swift
  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  
  // MARK: Custom accessors
  
  
  // MARK: Public
  
  
  // MARK: Private
```

### Implementazione di protocolli
Implementare eventuali protocolli creando `extension` della classe per separare logicamente il codice per contesto.

👍
```Swift
class MyViewController: UIViewController {
  // codice di classe
}

// MARK: - UITableViewDataSource
extension MyViewController: UITableViewDataSource {
  // implementazione dei metodi di UITableViewDataSource
}

// MARK: - UIScrollViewDelegate
extension MyViewController: UIScrollViewDelegate {
  // implementazione dei metodi di UIScrollViewDelegate
}
```

👎
```Swift
class MyViewController: UIViewController, UITableViewDataSource, UIScrollViewDelegate {
  // tutti i metodi
}
```

### Codice inutilizzato
Sempre per migliorare la leggibilità, in generale, è meglio rimuovere:
* codice non più utilizzato o sostituito da altre parti di codice
* vecchio codice commentato
* metodi che chiamano semplicemente la `superclass`

👍
```Swift
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  return elements.count
}
```

👎
```Swift
// Questo metodo non aggiunge nessuna implementazione specifica quindi è meglio ometterlo
override func didReceiveMemoryWarning() {
  super.didReceiveMemoryWarning()
  // Dispose of any resources that can be recreated.
}

override func numberOfSections(in tableView: UITableView) -> Int {
  // #warning Incomplete implementation, return the number of sections
  return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  // #warning Incomplete implementation, return the number of rows
  return elements.count
}
```

## Indentazione
* Indentare usando 2 spazi. Impostare Xcode nel modo seguente da `Preferences > Text Editing > Indentation`:
![Indentazione](https://github.com/tiknil/swift-style-guide/blob/master/images/indentation.png)
* Le parentesi graffe `{` `}` vanno sempre aperte sulla stessa riga e chiuse su un'altra riga.
> **CONSIGLIO:** Si può indentare automaticamente premendo `⌘+A` (seleziona tutto) e `Control+i` (indentazione automatica)

👍
```Swift
if user.isHappy {
  // Do something
} else {
  // Do something else
}
```

👎
```Swift
if user.isHappy
{
  // Do something
}
else {
  // Do something else
}
```

* I due punti `:` hanno sempre uno spazio a destra e zero a sinistra. Eccezioni: operatore ternario `? :`, dizionario vuoto `[:]` e `#selector` per metodi con paramteri senza nome `(_:)`.

👍
```Swift
class TestDatabase: Database {
  var data: [String: CGFloat] = ["A": 1.2, "B": 3.2]
}
```

👎
```Swift
class TestDatabase : Database {
  var data :[String:CGFloat] = ["A" : 1.2, "B":3.2]
}
```

## Design pattern

### MVC
Apple utilizza nel proprio SDK il design pattern **MVC (Model-View-Controller)**.

Tale pattern normalmente promette di separare in 3 livelli il codice:

* Il **Model** è dove risiedono i dati dell'app. Persistenza, oggetti che rappresentano i dati, parser e networking sono normalmente in questo livello.
* Il livello **View** è la UI dell'app. Le sue classi rappresentano un elemento visibile dall'utente e dovrebbero essere tipicamente riusabili come ad esempio un pulsante.
* Il **Controller** ha il compito di prendere i dati dal *Model* e mostrarli nelle *View* ed elaborare le azioni dell'utente.

I legami tra i 3 layer sono rappresentabili così:
![Original MVC](https://github.com/tiknil/swift-style-guide/blob/master/images/original-mvc.png)

Per come è strutturato *UIKit* la realtà è che Apple utilizza un MVC leggermente modificato:
![Original MVC](https://github.com/tiknil/swift-style-guide/blob/master/images/apple-mvc.png)

In pratica *View* e *Controller* risultano molto legati portando a scrivere la maggioranza del codice nei **UIVIewController**. In ambito iOS viene infatti spesso associata un'altra definizione all'acronimo MVC: **Massive-View-Controller**.

I problemi introdotti da questo pattern modificato sono:

1. Il codice è **difficilmente testabile**
2. **Scarsa riusabilità** delle *view*

Per risolvere tali problemi Tiknil ha deciso di utilizzare il pattern MVVM descritto di seguito.

### MVVM

Il design pattern **MVVM (Model-View-ViewModel)** applicato all'SDK di Apple risulta una naturale evoluzione di MVC:
![Original MVC](https://github.com/tiknil/swift-style-guide/blob/master/images/mvvm.png)

Il livello **View** comprende quindi sia **UIView** che **UIViewController**:

L'obiettivo del **ViewModel** è di essere una **rappresentazione astratta** della view a cui è associato. Ad esempio se la view deve mostrare nome e cognome dell'utente il viewmodel avrà due proprietà di tipo string che contengono queste informazioni.

Ciò introduce i seguenti vantaggi:

* È possibile **sostituire la view** associata al viewmodel senza problemi.
* È possibile separare dalla view eventuali trasformazioni dei dati presenti nel model. Esempio: formattazione di una data in base alla lingua. Questa operazione viene normalmente chiamata **Presentation logic**.
* È possibile eseguire **test funzionali** direttamente sul viewmodel.

Per un'analisi più dettagliata dell'evoluzione MVC => MVVM leggere [questo articolo](https://www.objc.io/issues/13-architecture/mvvm/) di **Ash Furrow**.

## Struttura del progetto
Nelle seguenti sezioni definiamo le best practices di Tiknil per l'impostazione di un progetto iOS in Swift chiamato **AwesomeApp**.

### Repository e CocoaPods
La root del repository avrà la seguente struttura:

```
|-- .git                         # Working copy di git
|-- AwesomeApp                   # Codice sorgente dell'app
|-- AwesomeAppTests              # Unit test automatici
|-- AwesomeAppUITests            # Test automatici di UI
|-- Pods                         # Cartella contenente le librerie CocoaPods
|-- Podfile.lock                 # Gestione versioni dei pods. Gestito automaticamente da CocoaPods
|-- .gitignore                   # Specifica i file da escludere dal repo
|-- Podfile                      # Configurazione dei pod 
|-- Readme.md                    # Readme con modifiche di versione
|-- AwesomeApp.xcodeproj         # File di progetto. Non va utilizzato
|-- AwesomeApp.xcworkspace       # File del workspace contenente configurazione dei CocoaPods.
```

Prima del primo commit sul repository git aggiungere questo file **.gitignore**:
![Original MVC](https://github.com/tiknil/swift-style-guide/blob/master/resources/.gitignore)

### Cartelle di progetto
La cartella contenente il codice sorgente dell'app avrà la seguente struttura:

```
|-- Helpers           # Classi di generico aiuto per tutto l'app. Es: Colors.swift
|-- Models            # Tutti gli oggetti model
|-- ViewModels        # Tutti i viewmodel eventualmente inseriti in sottocartelle di sezione
|-- Views             # Tutti i viewcontroller eventualmente inseriti in sottocartelle di sezione
    |-- Reusable      # Tutte le view riutilizzabili in altre view. Es: navigation bar custom
|-- UI                # Storyboards e xib.
    |-- Reusable      # Xib relativi alle view nella cartella Views/Reusable
|-- Services          # Oggetti che forniscono servizi come networking e persistenza
|-- Libraries         # Librerie create da Tiknil non importate come submodule
|-- Vendors           # Librerie di terzi non importate con CocoaPods o submodule
|-- Resources         # Assets, fonts, ecc
|-- Application       # Info.plist, AppDelegate.swift ed eventual bridging-header.h
```

Le cartelle al primo livello le creiamo fisicamente nel file system e le importiamo in modo che creino il gruppo logico nel progetto Xcode, mentre quelle al secondo livello possiamo anche lasciarle solo come gruppi logici.