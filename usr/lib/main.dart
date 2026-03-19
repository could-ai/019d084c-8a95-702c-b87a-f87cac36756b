import 'package:flutter/material.dart';

void main() {
  runApp(const StudyGuideApp());
}

// --- Models ---

class Flashcard {
  final String question;
  final String answer;

  Flashcard({required this.question, required this.answer});
}

class StudyTopic {
  final String title;
  final IconData icon;
  final Color color;
  final List<Flashcard> flashcards;

  StudyTopic({
    required this.title,
    required this.icon,
    required this.color,
    required this.flashcards,
  });
}

// --- Mock Data ---

final List<StudyTopic> mockTopics = [
  StudyTopic(
    title: 'Computer Science',
    icon: Icons.computer,
    color: Colors.blue,
    flashcards: [
      Flashcard(
          question: 'What is a Widget in Flutter?',
          answer: 'An immutable description of part of a user interface.'),
      Flashcard(
          question: 'What is the difference between StatelessWidget and StatefulWidget?',
          answer: 'StatelessWidget is immutable, whereas StatefulWidget maintains state that might change during the widget\'s lifetime.'),
      Flashcard(
          question: 'What is a REST API?',
          answer: 'Representational State Transfer. An architectural style for an application program interface (API) that uses HTTP requests to access and use data.'),
    ],
  ),
  StudyTopic(
    title: 'Biology',
    icon: Icons.biotech,
    color: Colors.green,
    flashcards: [
      Flashcard(
          question: 'What is the powerhouse of the cell?',
          answer: 'The Mitochondria.'),
      Flashcard(
          question: 'What is photosynthesis?',
          answer: 'The process by which green plants and some other organisms use sunlight to synthesize foods from carbon dioxide and water.'),
    ],
  ),
  StudyTopic(
    title: 'History',
    icon: Icons.account_balance,
    color: Colors.orange,
    flashcards: [
      Flashcard(
          question: 'In what year did the Titanic sink?',
          answer: '1912'),
      Flashcard(
          question: 'Who was the first President of the United States?',
          answer: 'George Washington'),
    ],
  ),
  StudyTopic(
    title: 'Mathematics',
    icon: Icons.calculate,
    color: Colors.redAccent,
    flashcards: [
      Flashcard(
          question: 'What is the value of Pi to two decimal places?',
          answer: '3.14'),
      Flashcard(
          question: 'What is the Pythagorean theorem?',
          answer: 'a² + b² = c²'),
    ],
  ),
];

// --- App Entry Point ---

class StudyGuideApp extends StatelessWidget {
  const StudyGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}

// --- Home Screen ---

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Study Guides', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Topic',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: mockTopics.length,
                itemBuilder: (context, index) {
                  final topic = mockTopics[index];
                  return TopicCard(topic: topic);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Adding new topics will be available once connected to a database!')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Guide'),
      ),
    );
  }
}

class TopicCard extends StatelessWidget {
  final StudyTopic topic;

  const TopicCard({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopicDetailScreen(topic: topic),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                topic.color.withOpacity(0.7),
                topic.color,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  topic.icon,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  topic.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${topic.flashcards.length} Cards',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Topic Detail Screen (Flashcards) ---

class TopicDetailScreen extends StatefulWidget {
  final StudyTopic topic;

  const TopicDetailScreen({super.key, required this.topic});

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  int _currentIndex = 0;

  void _nextCard() {
    if (_currentIndex < widget.topic.flashcards.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasCards = widget.topic.flashcards.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
        backgroundColor: widget.topic.color.withOpacity(0.2),
      ),
      body: hasCards
          ? Column(
              children: [
                const SizedBox(height: 20),
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Card ${_currentIndex + 1} of ${widget.topic.flashcards.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      LinearProgressIndicator(
                        value: (_currentIndex + 1) / widget.topic.flashcards.length,
                        backgroundColor: Colors.grey[300],
                        color: widget.topic.color,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Flashcard
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: FlashcardWidget(
                      flashcard: widget.topic.flashcards[_currentIndex],
                      color: widget.topic.color,
                      // Force widget rebuild when card changes to reset flip state
                      key: ValueKey(_currentIndex), 
                    ),
                  ),
                ),
                // Navigation Buttons
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _currentIndex > 0 ? _previousCard : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _currentIndex < widget.topic.flashcards.length - 1
                            ? _nextCard
                            : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: Text('No flashcards available for this topic.'),
            ),
    );
  }
}

// --- Flashcard Widget (Tap to flip) ---

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;
  final Color color;

  const FlashcardWidget({
    super.key,
    required this.flashcard,
    required this.color,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  bool _showAnswer = false;

  void _toggleCard() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          // A simple fade and scale transition for the flip effect
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: _showAnswer
            ? _buildCardSide(
                key: const ValueKey('answer'),
                text: widget.flashcard.answer,
                isAnswer: true,
              )
            : _buildCardSide(
                key: const ValueKey('question'),
                text: widget.flashcard.question,
                isAnswer: false,
              ),
      ),
    );
  }

  Widget _buildCardSide({
    required Key key,
    required String text,
    required bool isAnswer,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isAnswer ? widget.color.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: widget.color.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isAnswer ? 'ANSWER' : 'QUESTION',
              style: TextStyle(
                color: widget.color,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isAnswer ? 20 : 24,
                      fontWeight: isAnswer ? FontWeight.normal : FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tap to flip',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
