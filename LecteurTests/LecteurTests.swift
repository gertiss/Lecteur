//
//  LecteurTests.swift
//  LecteurTests
//
//  Created by Gérard Tisseau on 16/11/2022.
//

import XCTest
@testable import Lecteur
import RegexBuilder

final class LecteurTests: XCTestCase {
    
    override func setUpWithError() throws {
        print()
    }
    
    override func tearDownWithError() throws {
        print()
    }
    
    /// Application de Mirror pour analyser un résultat output d'un match avec Regex.
    /// output est un un tuple dont le premier composant est une Substring.
    /// Utilisé dans le protocole AvecLecteurRegex, fonction captureGlobale(sortie).
    /// Le but est d'extraire cette Substring et de la transformer en String.
    func testMirror() {
        print("> sortie")
        let sortie = ("abc"[...], 1)
        print(String(reflecting: sortie))
        
        let mirror = Mirror(reflecting: sortie)
        XCTAssertEqual(mirror.displayStyle, .tuple)
        print(mirror.subjectType)
        let subjectType = "\(mirror.subjectType)"
        XCTAssert(subjectType.hasPrefix("(Substring"))
        
        
        // On vérifie qu'il a au moins un composant
        let composants = mirror.children
        XCTAssert(composants.count > 0)
        
        print("\n> Composant0")
        // On vérifie le type du composant 0
        let composant0 = composants.first!
        XCTAssertEqual(composant0.label, ".0")
        let valeur0 = composant0.value
        let mirror0 = Mirror(reflecting: valeur0)
        print(String(reflecting: valeur0))
        print("style", mirror0.displayStyle as Any)
        let typeDescr = "\(mirror0.subjectType)"
        print("type", typeDescr)
        XCTAssertEqual(typeDescr, "String")
        let value0 = composant0.value
        let string = "\(value0)"
        XCTAssertEqual(string, "abc")
        
        print("\n> Composant1")
        // On vérifie le type du composant 1
        let composant1 = composants.dropFirst().first
        let valeur1 = composant1?.value
        let mirror1 = Mirror(reflecting: valeur1 as Any)
        print(String(reflecting: valeur1))
        print(mirror1.displayStyle as Any)
        print(mirror1.subjectType)
    }
    
    func testLecteurString() {
        XCTAssertEqual("abc".lecteur.lire("abc").texte,
                       "􀆅 abc 􀄫\"\"")
        XCTAssertEqual("def".lecteur.lire("abc").texte,
                       "􀅾 On attend \"def\" 􀄫\"abc\"")
    }
    
    func testLecteurMot() {
        XCTAssertEqual(Mot.lecteur.lire(" abc def ").texte,
                  "􀆅 Mot(\"abc\") 􀄫\"def\""
        )
        XCTAssertEqual(Mot.lecteur.lire(" ").texte,
                       "􀅾 On attend Mot 􀄫\" \""
        )
   }
 
    func testOptionnel() {
        let lecteur = Mot.lecteur.optionnel()
        let lecture = lecteur.lire("a b")
        XCTAssert(lecture.estSucces)
        XCTAssertEqual(lecture.reste, "b")
        XCTAssertEqual(lecture.valeur, Mot("a"))
        
        let lectureVide = lecteur.lire("@")
        XCTAssert(lectureVide.estSucces)
        XCTAssertEqual(lectureVide.reste, "@")
        XCTAssertEqual(lectureVide.valeur, Mot?.none)
    }
    
    func testSuiviDe() {
        let lecteur = Mot.lecteur.suiviDe(Mot.lecteur)
        let lectureSucces = lecteur.lire("a b c")
        XCTAssert(lectureSucces.estSucces)
        XCTAssertEqual(lectureSucces.valeur?.0, Mot("a"))
        XCTAssertEqual(lectureSucces.valeur?.1, Mot("b"))
        XCTAssertEqual(lectureSucces.reste, "c")
        
        let lectureEchec = lecteur.lire("a @")
        XCTAssert(lectureEchec.estEchec)
        // On a lu un seul mot a, il reste @
        XCTAssertEqual(lectureEchec.reste, "@")
        XCTAssertEqual(lectureEchec.texte, "􀅾 On attend Mot 􀄫\"@\"")
    }
    
    func testSuiviDe2() {
        let lecteur = Mot.lecteur.suiviDe2(Mot.lecteur, Mot.lecteur)
        let lectureSucces = lecteur.lire("a b c d")
        XCTAssert(lectureSucces.estSucces)
        XCTAssertEqual(lectureSucces.valeur?.0, Mot("a"))
        XCTAssertEqual(lectureSucces.valeur?.1, Mot("b"))
        XCTAssertEqual(lectureSucces.valeur?.2, Mot("c"))
        XCTAssertEqual(lectureSucces.reste, "d")
        
        let lectureEchec = lecteur.lire("a b @")
        XCTAssert(lectureEchec.estEchec)
        // On a lu a et b, il reste @
        XCTAssertEqual(lectureEchec.reste, "@")
        XCTAssertEqual(lectureEchec.texte, "􀅾 On attend Mot 􀄫\"@\"")
    }
    
    func testSuiviDe3() {
        let lecteur = Mot.lecteur.suiviDe3(Mot.lecteur, Mot.lecteur, Mot.lecteur)
        let lectureSucces = lecteur.lire("a b c d e")
        XCTAssert(lectureSucces.estSucces)
        XCTAssertEqual(lectureSucces.valeur?.0, Mot("a"))
        XCTAssertEqual(lectureSucces.valeur?.1, Mot("b"))
        XCTAssertEqual(lectureSucces.valeur?.2, Mot("c"))
        XCTAssertEqual(lectureSucces.valeur?.3, Mot("d"))
        XCTAssertEqual(lectureSucces.reste, "e")
        
        let lectureEchec = lecteur.lire("a b c @")
        XCTAssert(lectureEchec.estEchec)
        XCTAssertEqual(lectureEchec.reste, "@")
        XCTAssertEqual(lectureEchec.texte, "􀅾 On attend Mot 􀄫\"@\"")
    }
    
    func testOu() {
        // Attention à l'ordre des clauses
        let lecteur = Mot.lecteur.suiviDe(Mot.lecteur).ou(Mot.lecteur)
        let lecture = lecteur.lire(" a b c")
        XCTAssert(lecture.estSucces) // cas0 -> (Mot("a"), Mot("b"))
        XCTAssertEqual(lecture.reste, "c")
        
        let lecture1 = lecteur.lire("a @")
        XCTAssert(lecture1.estSucces) // cas1 -> Mot("a")
        XCTAssertEqual(lecture1.reste, "@")
    }

    func testLecteurListeAvecSeparateur() {
        // Liste de mots séparés par des virgules
        let lecteur = Mot.lecteur.listeAvecSeparateur(",")
        let lecture = lecteur.lire("a, b, c  def")
        XCTAssert(lecture.estSucces)
        XCTAssertEqual(lecture.valeur, [Mot("a"), Mot("b"), Mot("c")])
        XCTAssertEqual(lecture.reste, "def")
        
        let lectureVide = lecteur.lire("@")
        XCTAssert(lectureVide.estSucces)
        XCTAssertEqual(lectureVide.valeur, [])
        XCTAssertEqual(lectureVide.reste, "@")
    }
    
    func testLecteurListeNonVideAvecSeparateur() {
        // Liste de mots séparés par des virgules
        let lecteur = Mot.lecteur.listeNonVideAvecSeparateur(",")
        let lecture = lecteur.lire("a, b, c  def")
        XCTAssert(lecture.estSucces)
        XCTAssertEqual(lecture.valeur, [Mot("a"), Mot("b"), Mot("c")])
        XCTAssertEqual(lecture.reste, "def")
        
        let lectureVide = lecteur.lire("@")
        XCTAssert(lectureVide.estEchec)
        XCTAssertEqual(lectureVide.reste, "@")
        XCTAssertEqual(lectureVide.texte, "􀅾 On attend Mot 􀄫\"@\"")
    }
    
    
    func testLecteurAvecMarqueFin() {
        let lecteur = Mot.lecteur.avecMarqueFin(Token("\n").lecteur)
        let lecture = lecteur.lire(" a \n suite")
        XCTAssert(lecture.estSucces)
        XCTAssertEqual(lecture.reste, "suite")
        print(lecture.texte)
    }
    
    func testCaptureGlobale() {
        
        struct Word: AvecLecteurRegex {
            var texte: String
            static let regex = Regex<(Substring)> {
                OneOrMore { .word }
            }
            static func valeur(_ sortie: (Substring)) -> Word {
                Word(texte: String(sortie))
            }
            
            typealias SortieRegex = (Substring)
            
            var sourceRelisible: String {
                ""
            }
            
            var description: String {
                "Word(texte: \(texte.debugDescription))"
            }
        }
        
        let lecture = Word.lecteur.lire("abc")
        print(lecture.texte)
    }
    
    func testListeNonVide() {
        let lecteur = Mot.lecteur.listeNonVide()
        let lecture = lecteur.lire("a b c")
        XCTAssert(lecture.estSucces)
        XCTAssertEqual(lecture.reste, "")
        print(lecture.texte)
                
    }
    
    func testErreurListeNonVideAvecSeparateur() {
        let lecteur = Mot.lecteur.listeNonVideAvecSeparateur(",")
            .mapValeur { mots in
                mots
            }
        let lecture = lecteur.lireTout("a b, c")
        XCTAssert(lecture.estEchec)
        // On a lu a, ce qui donne une liste [a]
        // mais il y a un reste et on n'en veut pas à cause de lireTout
        XCTAssertEqual(lecture.reste, "b, c")
        print(lecture.texte)
    }
    
    func testErreurSuiviDeAvecSeparateur() {
        let lecteur = Mot.lecteur.suiviDeAvecSeparateur(lecteur1: Mot.lecteur, separateur: Token(",").lecteur)
        
        let lecture = lecteur.lireTout("a b, c")
        XCTAssert(lecture.estEchec)
        // a lu avec succès, mais il doit y avoir un second mot
        // donc on attend une virgule avant b
        XCTAssertEqual(lecture.reste, "b, c")
        print(lecture.texte)
        
    }
    
    func testErreurSuiviDe() {
        let lecteur = Mot.lecteur.suiviDe(Mot.lecteur)
        let lecture = lecteur.lire("a, b")
        XCTAssert(lecture.estEchec)
        // On a lu a mais on attend un second mot, sans séparateur
        XCTAssertEqual(lecture.reste, ", b")
        print(lecture.texte)

    }
    
    func testToken() {
        let lecteur = Token("abc").lecteur
        let lecture = lecteur.lire(" abc ") // espaces autorisés
        XCTAssert(lecture.estSucces)
        XCTAssertEqual(lecture.valeur, Token("abc"))
        
        let lectureEchec = lecteur.lire("xyz")
        XCTAssert(lectureEchec.estEchec)
        // On attend abc mais on a lu xyz
        print(lectureEchec.texte)
    }
    
}
