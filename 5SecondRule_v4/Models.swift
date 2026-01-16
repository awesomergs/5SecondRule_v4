import Foundation

struct Deck: Identifiable, Codable {
    let id: UUID
    let title: String
    let emoji: String
    var isEnabled: Bool
    let questions: [Question]

    init(id: UUID = UUID(), title: String, emoji: String, isEnabled: Bool = true, questions: [Question]) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.isEnabled = isEnabled
        self.questions = questions
    }
}

struct Question: Identifiable, Codable {
    let id: UUID
    let prompt: String

    init(id: UUID = UUID(), prompt: String) {
        self.id = id
        self.prompt = prompt
    }
}

struct GameState {
    var players: [String]
    var questions: [Question]

    var roundsPerPlayer: Int

    var turnsPlayed: Int

    var currentPlayerIndex: Int
    var currentQuestionIndex: Int

    var scores: [String: Int]

    var currentPlayer: String { players[currentPlayerIndex] }

    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }

    var totalTurnsToPlay: Int {
        players.count * roundsPerPlayer
    }

    var isGameOver: Bool {
        turnsPlayed >= totalTurnsToPlay
    }

//    var currentPlayerRoundNumber: Int {
//        // 0-based turn index for this player = turnsPlayed / players.count (integer division)
//        min((turnsPlayed / max(players.count, 1)) + 1, roundsPerPlayer)
//    }

    mutating func addPointToCurrentPlayer() {
        scores[currentPlayer, default: 0] += 1
    }

    mutating func advanceTurn() {
        currentQuestionIndex += 1
        currentPlayerIndex = (currentPlayerIndex + 1) % max(players.count, 1)
        turnsPlayed += 1
    }
}



extension Deck {
    static let sample: [Deck] = [
        // MARK: - Social Media Brainrot
        Deck(
            title: "Social Media Brainrot",
            emoji: "📱",
            isEnabled: true,
            questions: [
                Question(prompt: "Name 3 apps you open without thinking"),
                Question(prompt: "Name 3 Italian brainrots"),
                Question(prompt: "Name 3 things people comment on every post"),
                Question(prompt: "Name 3 reasons a video goes viral"),
                Question(prompt: "Name 3 things you’d see in a “day in my life”"),
                Question(prompt: "Name 3 things people do for “aesthetic”"),
                Question(prompt: "Name 3 things you’d put in a “photo dump”"),
                Question(prompt: "Name 3 things influencers always say"),
                Question(prompt: "Name 3 types of cringe captions"),
                Question(prompt: "Name 3 emojis you see way too much"),
                Question(prompt: "Name 3 “content” ideas people recycle"),
                Question(prompt: "Name 3 reasons people start drama online"),
                Question(prompt: "Name 3 things you’d do for clout"),
                Question(prompt: "Name 3 things you’d see in a GRWM"),
                Question(prompt: "Name 3 things people humblebrag about"),
                Question(prompt: "Name 3 things you’d find on someone’s “link in bio”"),
                Question(prompt: "Name 3 red flags in someone’s profile"),
                Question(prompt: "Name 3 ways people procrastinate online"),
                Question(prompt: "Name 3 things you’d see on a ‘For You’ page")
            ]
        ),

        // MARK: - Pop Culture
        
        Deck(
            title: "Pop Culture",
            emoji: "🎬",
            isEnabled: true,
            questions: [
                Question(prompt: "Name 3 Marvel characters"),
                Question(prompt: "Name 3 Disney movies"),
                Question(prompt: "Name 3 famous pop stars"),
                Question(prompt: "Name 3 animated TV shows"),
                Question(prompt: "Name 3 streaming services"),
                Question(prompt: "Name 3 reality TV shows"),
                Question(prompt: "Name 3 movie genres"),
                Question(prompt: "Name 3 sitcoms"),
                Question(prompt: "Name 3 famous fictional villains"),
                Question(prompt: "Name 3 famous fictional sidekicks"),
                Question(prompt: "Name 3 famous movie franchises"),
                Question(prompt: "Name 3 famous TV characters"),
                Question(prompt: "Name 3 famous directors"),
                Question(prompt: "Name 3 award shows"),
                Question(prompt: "Name 3 video game franchises"),
                Question(prompt: "Name 3 superhero movies"),
                Question(prompt: "Name 3 famous memes (describe them)"),
                Question(prompt: "Name 3 songs that everyone knows the chorus to")
            ]
        ),

        // MARK: - USC-Specific
        Deck(
            title: "USC-Specific",
            emoji: "✌️",
            isEnabled: true,
            questions: [
                Question(prompt: "Name 3 buildings on USC’s campus"),
                Question(prompt: "Name 3 places to study on campus"),
                Question(prompt: "Name 3 lecture halls @ USC"),
                Question(prompt: "Name 3 spots people take photos on campus"),
                Question(prompt: "Name 3 stores in USC Village"),
                Question(prompt: "Name 3 places to eat in USC Village"),
                Question(prompt: "Name 3 reasons people go to the Village"),
                Question(prompt: "Name 3 USC schools or colleges"),
                Question(prompt: "Name 3 Marshall clubs"),
                Question(prompt: "Name 3 Viterbi clubs"),
                Question(prompt: "Name 3 first-year dorms @ USC"),
            ]
        )
    ]
}
