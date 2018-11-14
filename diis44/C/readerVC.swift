import UIKit
import SnapKit

class readerVC:UIViewController,NSLayoutManagerDelegate {

    var mainView = UIView()
    var textView = UITextView()
    var fontBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Snapkit ViewSetup
        viewSetup()
        navigationController?.hidesBarsOnTap = true
        
        let scrollingView = UIScrollView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(view.bounds.size.width - 30), height: CGFloat(view.bounds.size.height - 100)))

        // we will set the contentSize after determining how many pages get filled with text
        //scrollingView.contentSize = CGSize(width: CGFloat((view.bounds.size.width - 20) * pageNumber), height: CGFloat(view.bounds.size.height - 20))
        scrollingView.backgroundColor = UIColor.white
        scrollingView.isPagingEnabled = true
        scrollingView.isDirectionalLockEnabled = true
        scrollingView.center = view.center
        scrollingView.bounces = false
        scrollingView.contentInsetAdjustmentBehavior = .never
        scrollingView.showsVerticalScrollIndicator = false
        scrollingView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollingView)
        
    
        
        let textString = "Il professor Langdon sollevò lo sguardo verso il cane alto una quindicina di metri seduto nella piazza. Il pelo dell’animale era un tappeto vivente d’erba e fiori profumati. “Io ce la sto mettendo tutta per trovarti bello” pensò. “Ci sto davvero provando.” Osservò la creatura ancora per qualche istante, poi proseguì lungo una passerella sospesa e scese una larga rampa di scalini la cui superficie discontinua aveva lo scopo di costringere il visitatore ad alterare il ritmo dell’andatura. “E ci riesce benissimo” decise Langdon, rischiando di cadere per ben due volte sui gradini irregolari. Arrivato in fondo alla scalinata, si fermò di botto, fissando l’enorme oggetto che incombeva minaccioso più avanti. “Ora posso dire di averle viste proprio tutte.” Davanti a lui si ergeva un ragno gigantesco, una vedova nera, le cui sottili zampe di ferro sostenevano un corpo tondeggiante a un’altezza di almeno dieci metri. Sotto l’addome del ragno era sospeso un sacco ovigero di rete metallica pieno di sfere di vetro. «Si chiama Maman» disse una voce. Langdon abbassò lo sguardo e vide un uomo snello in piedi sotto il ragno. Indossava uno sherwani di broccato nero e sfoggiava un paio di baffi arricciati alla Salvador Dalí al limite del ridicolo. «Mi chiamo Fernando» proseguì l’uomo «e sono qui per darle il benvenuto al museo.» Esaminò una serie di targhette di riconoscimento posate sul tavolo davanti a lui. «Posso avere il suo nome, per favore?» «Certamente. Robert Langdon.» L’uomo alzò lo sguardo di scatto. «Ah, mi scusi! Non l’avevo riconosciuta, signore!» “Faccio fatica a riconoscermi io” pensò Langdon, avanzando impacciato in frac nero con farfallino e gilet bianchi. “Sembro un Whiffenpoof.” Il classico frac di Langdon aveva quasi trent’anni e risaliva ai tempi in cui lui era membro dell’Ivy Club di Princeton ma, grazie al costante regime di nuotate quotidiane, gli andava ancora alla perfezione. Nella fretta di fare i bagagli, aveva preso il portabiti sbagliato dall’armadio, lasciando a casa lo smoking che indossava di solito in quelle occasioni. «L’invito diceva “bianco e nero”. Spero che il frac sia adatto.» «Il frac è un classico! Lei è elegantissimo!» L’uomo gli si avvicinò a passi svelti e gli appiccicò una targhetta con il nome sul risvolto della giacca. «È un onore conoscerla, signore» aggiunse. «Sicuramente sarà già stato da noi?» Langdon osservò da sotto le zampe del ragno l’edificio scintillante davanti a loro. «In realtà mi vergogno a dirlo, ma non ci sono mai stato.» «No!» L’uomo finse di cadere all’indietro. «Non è un amante dell’arte moderna?» Langdon aveva sempre apprezzato la sfida dell’arte moderna… in particolare gli piaceva cercare di capire il motivo per cui determinate opere erano considerate dei capolavori: i quadri di Jackson Pollock realizzati con la tecnica del dripping, i barattoli di zuppa Campbell di Andy Warhol, i semplici rettangoli di colore di Mark Rothko. Detto questo, Langdon si sentiva molto più a proprio agio a discutere del simbolismo religioso di Hieronymus Bosch o delle pennellate di Francisco Goya. «Ho gusti più classici» rispose. «Me la cavo meglio con da Vinci che con de Kooning.» «Ma da Vinci e de Kooning sono così simili!» Langdon sorrise, paziente. «Allora è evidente che ho parecchio da imparare su de Kooning.» «Be’, è nel posto giusto!» L’uomo indicò con il braccio l’enorme edificio. «In questo museo troverà la miglior collezione d’arte moderna sulla terra! Spero se la goda.» «È quello che intendo fare» rispose Langdon. «Vorrei solo sapere perché mi trovo qui.» «Lei come tutti gli altri!» L’uomo si fece una bella risata, scuotendo la testa. «Il suo ospite è stato molto misterioso sullo scopo dell’evento di questa sera. Neppure il personale del museo sa cosa succederà. Il mistero è metà del divertimento… Girano un sacco di voci! Ci sono centinaia di ospiti dentro, molte facce famose, e nessuno ha la minima idea di cosa ci aspetti stasera!» Langdon sorrise divertito. Poche persone al mondo avrebbero avuto la sfrontatezza di spedire degli inviti all’ultimo minuto dicendo in sostanza: “Presentati qui sabato sera. Fidati di me”. E ancora meno sarebbero riuscite a convincere centinaia di VIP a mollare tutto e a saltare su un aereo per il Nord della Spagna per partecipare all’evento. Langdon uscì da sotto il ragno e proseguì lungo la passerella, alzando lo sguardo verso un enorme striscione rosso che sventolava sopra di lui. UNA SERATA CON EDMOND KIRSCH “A Edmond è sempre piaciuto mettersi in mostra” pensò, divertito. Una ventina di anni prima, il giovane Eddie Kirsch era stato uno dei primi studenti di Langdon all’università di Harvard… un ragazzo con una zazzera ribelle, appassionato di computer, il cui interesse per i codici lo aveva portato a iscriversi al seminario di Langdon per gli studenti del primo anno: “Codici, cifrari e il linguaggio dei simboli”. "
        
        let textStorage = NSTextStorage(string: textString)
        let textLayout = NSLayoutManager()
        textStorage.addLayoutManager(textLayout)
        textLayout.delegate = self
        
        var r = CGRect(x: 0, y: 0, width: scrollingView.frame.size.width, height: scrollingView.frame.size.height)
        var i: Int = 0
        
        // this is what we'll use to track the "progress" of filling the "screens of textviews"
        // each time through, we'll get the last Glyph rendered...
        // if it's equal to the total number of Glyphs, we know we're done
        var lastRenderedGlyph = 0
        while lastRenderedGlyph < textLayout.numberOfGlyphs {

            let textContainer = NSTextContainer(size: scrollingView.frame.size)
            textLayout.addTextContainer(textContainer)
            let textView = UITextView(frame: r, textContainer: textContainer)
            r.origin.x += r.width
            textView.textAlignment = .left
            //FontSize
            textView.font = .systemFont(ofSize: 21)
            textView.tag = i
            i += 1
            textView.contentSize = scrollingView.contentSize
            scrollingView.addSubview(textView)
            // get the last Glyph rendered into the current textContainer
            lastRenderedGlyph = NSMaxRange(textLayout.glyphRange(for: textContainer))
        }
        
        //last textView rect to set contentSize
        scrollingView.contentSize = CGSize(width: r.origin.x, height: r.size.height)
        print("Actual number of pages =", i)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
        navigationController?.navigationBar.barTintColor = UIColor.clear
    }
    
}

extension readerVC {
     //snapkit View
    func viewSetup(){
        mainView.backgroundColor = UIColor.white
        self.view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}
