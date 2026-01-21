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
        Deck(
            //MARK: - Base Deck
            title: "Base Deck",
            emoji: "🧠",
            isEnabled: true,
            questions: [
                Question(prompt: "Name 3 colors"),
                Question(prompt: "Name 3 fruits"),
                Question(prompt: "Name 3 vegetables"),
                Question(prompt: "Name 3 animals"),
                Question(prompt: "Name 3 drinks"),
                Question(prompt: "Name 3 things you eat for breakfast"),
                Question(prompt: "Name 3 things you wear"),
                Question(prompt: "Name 3 things you find in a kitchen"),
                Question(prompt: "Name 3 things you find in a bathroom"),
                Question(prompt: "Name 3 things you do every day"),
                Question(prompt: "Name 3 types of weather"),
                Question(prompt: "Name 3 things you can sit on"),
                Question(prompt: "Name 3 things you see outside"),
                Question(prompt: "Name 3 things you’d pack for a trip"),
                Question(prompt: "Name 3 things you’d find in a backpack"),
                Question(prompt: "Name 3 things you’d find in a bedroom"),
                Question(prompt: "Name 3 things that make noise"),
                Question(prompt: "Name 3 things that are soft"),
                Question(prompt: "Name 3 things that are hard"),
                Question(prompt: "Name 3 things you can open and close"),
                Question(prompt: "Name 3 animals that can fly"),
                Question(prompt: "Name 3 animals that live in water"),
                Question(prompt: "Name 3 types of shoes"),
                Question(prompt: "Name 3 things with wheels"),
                Question(prompt: "Name 3 things you’d find at a party"),
                Question(prompt: "Name 3 things that are round"),
                Question(prompt: "Name 3 things that are hot"),
                Question(prompt: "Name 3 things that are cold"),
                Question(prompt: "Name 3 things you plug in"),
                Question(prompt: "Name 3 things that smell good"),
                Question(prompt: "Name 3 things that smell bad"),
                Question(prompt: "Name 3 things people collect"),
                Question(prompt: "Name 3 things you can lose easily"),
                Question(prompt: "Name 3 things people complain about"),
                Question(prompt: "Name 3 things you’d see in a store"),
                Question(prompt: "Name 3 things you’d see on a desk"),
                Question(prompt: "Name 3 things you’d see in a car"),
                Question(prompt: "Name 3 types of cheese"),
                Question(prompt: "Name 3 pizza toppings"),
                Question(prompt: "Name 3 snacks"),
                Question(prompt: "Name 3 fast foods"),
                Question(prompt: "Name 3 desserts"),
                Question(prompt: "Name 3 ice cream flavors"),
                Question(prompt: "Name 3 candies"),
                Question(prompt: "Name 3 types of bread"),
                Question(prompt: "Name 3 soups"),
                Question(prompt: "Name 3 drinks with caffeine"),
                Question(prompt: "Name 3 things you’d order at a café"),
                Question(prompt: "Name 3 things you’d order at a restaurant"),
                Question(prompt: "Name 3 things you bake"),
                Question(prompt: "Name 3 spices"),
                Question(prompt: "Name 3 herbs"),
                Question(prompt: "Name 3 foods you eat with your hands"),
                Question(prompt: "Name 3 things that are red"),
                Question(prompt: "Name 3 things that are blue"),
                Question(prompt: "Name 3 things that are green"),
                Question(prompt: "Name 3 things that are yellow"),
                Question(prompt: "Name 3 things that are black"),
                Question(prompt: "Name 3 things made of metal"),
                Question(prompt: "Name 3 things made of wood"),
                Question(prompt: "Name 3 things made of plastic"),
                Question(prompt: "Name 3 things made of glass"),
                Question(prompt: "Name 3 things made of gold"),
                Question(prompt: "Name 3 things that float"),
                Question(prompt: "Name 3 things that sink"),
                Question(prompt: "Name 3 things you can break"),
                Question(prompt: "Name 3 things you can fix"),
                Question(prompt: "Name 3 things that fold"),
                Question(prompt: "Name 3 things you can stack"),
                Question(prompt: "Name 3 things you can throw"),
                Question(prompt: "Name 3 things you can catch"),
                Question(prompt: "Name 3 sweet foods"),
                Question(prompt: "Name 3 salty snacks"),
                Question(prompt: "Name 3 sour foods"),
                Question(prompt: "Name 3 spicy foods"),
                Question(prompt: "Name 3 hot drinks"),
                Question(prompt: "Name 3 cold drinks"),
                Question(prompt: "Name 3 indoor activities"),
                Question(prompt: "Name 3 outdoor activities"),
                Question(prompt: "Name 3 things you do alone"),
                Question(prompt: "Name 3 things you do with friends"),
                Question(prompt: "Name 3 quiet activities"),
                Question(prompt: "Name 3 loud activities"),
                Question(prompt: "Name 3 things you do in the morning"),
                Question(prompt: "Name 3 things you do at night"),
                Question(prompt: "Name 3 things you do on weekends"),
                Question(prompt: "Name 3 things you do when bored"),
                Question(prompt: "Name 3 things you do when stressed"),
                Question(prompt: "Name 3 things you do to relax"),
                Question(prompt: "Name 3 things you do for fun"),
                Question(prompt: "Name 3 things you do to waste time"),
                Question(prompt: "Name 3 things people forget to do"),
                Question(prompt: "Name 3 things people overthink"),
                Question(prompt: "Name 3 things people procrastinate"),
                Question(prompt: "Name 3 things people lose"),
                Question(prompt: "Name 3 things people misplace"),
                Question(prompt: "Name 3 things people break accidentally"),
                Question(prompt: "Name 3 things people spill"),
                Question(prompt: "Name 3 things people drop"),
                Question(prompt: "Name 3 things people borrow"),
                Question(prompt: "Name 3 things people Google"),
                Question(prompt: "Name 3 things people talk about"),
                Question(prompt: "Name 3 words that start with B"),
                Question(prompt: "Name 3 words that start with S"),
                Question(prompt: "Name 3 words that start with T"),
                Question(prompt: "Name 3 words that start with R"),
                Question(prompt: "Name 3 things that have buttons"),
                Question(prompt: "Name 3 things with screens"),
                Question(prompt: "Name 3 things that use batteries"),
                Question(prompt: "Name 3 things that need electricity"),
                Question(prompt: "Name 3 things you charge"),
                Question(prompt: "Name 3 things you lock"),
                Question(prompt: "Name 3 things you turn on")
            ]
        ),
        
        // MARK:  Pop Culture
        
        Deck(
            title: "Pop Culture Lite",
            emoji: "🎬",
            isEnabled: true,
            questions: [
                Question(prompt: "Name 3 movie genres"),
                Question(prompt: "Name 3 TV show genres"),
                Question(prompt: "Name 3 famous movies"),
                Question(prompt: "Name 3 popular TV shows"),
                Question(prompt: "Name 3 animated movies"),
                Question(prompt: "Name 3 animated TV shows"),
                Question(prompt: "Name 3 live-action TV shows"),
                Question(prompt: "Name 3 movie sequels"),
                Question(prompt: "Name 3 movie characters"),
                Question(prompt: "Name 3 famous fictional villains"),
                Question(prompt: "Name 3 famous fictional heroes"),
                Question(prompt: "Name 3 famous actors"),
                Question(prompt: "Name 3 famous actresses"),
                Question(prompt: "Name 3 famous singers"),
                Question(prompt: "Name 3 famous bands"),
                Question(prompt: "Name 3 celebrities everyone knows"),
                Question(prompt: "Name 3 celebrities who started as kids"),
                Question(prompt: "Name 3 music genres"),
                Question(prompt: "Name 3 pop songs"),
                Question(prompt: "Name 3 bands"),
                Question(prompt: "Name 3 streaming services"),
                Question(prompt: "Name 3 things people binge-watch"),
                Question(prompt: "Name 3 famous catchphrases"),
                Question(prompt: "Name 3 famous movie quotes"),
                Question(prompt: "Name 3 fictional worlds"),
                Question(prompt: "Name 3 famous sidekicks"),
                Question(prompt: "Name 3 famous villains people secretly like"),
                Question(prompt: "Name 3 characters people dressed as for Halloween"),
                Question(prompt: "Name 3 things people watch on YouTube"),
                Question(prompt: "Name 3 viral videos"),
                Question(prompt: "Name 3 social media platforms"),
                Question(prompt: "Name 3 meme templates")
            ]
        ),
        //MARK: Internet Brain
        Deck(
            title: "Geography Lite",
            emoji: "🌍",
            isEnabled: true,
            questions: [
                Question(prompt: "Name 3 continents"),
                Question(prompt: "Name 3 oceans or seas"),
                Question(prompt: "Name 3 countries"),
                Question(prompt: "Name 3 large countries"),
                Question(prompt: "Name 3 small countries"),
                Question(prompt: "Name 3 island countries"),
                Question(prompt: "Name 3 countries in Europe"),
                Question(prompt: "Name 3 countries in Asia"),
                Question(prompt: "Name 3 countries in Africa"),
                Question(prompt: "Name 3 countries in South America"),
                Question(prompt: "Name 3 coastal cities"),
                Question(prompt: "Name 3 cities near water"),
                Question(prompt: "Name 3 cities people vacation in"),
                Question(prompt: "Name 3 deserts"),
                Question(prompt: "Name 3 mountain ranges"),
                Question(prompt: "Name 3 rivers"),
                Question(prompt: "Name 3 forests"),
                Question(prompt: "Name 3 jungles or rainforests"),
                Question(prompt: "Name 3 natural wonders"),
                Question(prompt: "Name 3 hot places"),
                Question(prompt: "Name 3 cold places"),
                Question(prompt: "Name 3 rainy places"),
                Question(prompt: "Name 3 dry places"),
                Question(prompt: "Name 3 places with snow"),
                Question(prompt: "Name 3 tropical places"),
                Question(prompt: "Name 3 countries with red on their flag"),
                Question(prompt: "Name 3 countries with blue on their flag"),
                Question(prompt: "Name 3 countries with stripes on their flag")
            ]
        ),
        // MARK: - USC-Specific
        Deck(
            title: "USC-Specific",
            emoji: "✌️",
            isEnabled: false,
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
                Question(prompt: "Name 3 places sophmores live on campus @ USC"),
                Question(prompt: "Name 3 libraries on USC’s campus"),
                Question(prompt: "Name 3 Viterbi majors"),
                Question(prompt: "Name 3 Dornsife majors"),
                Question(prompt: "Name 3 Frats at USC")
            ]
        )
    ]
}
