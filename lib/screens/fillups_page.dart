import 'package:flutter/material.dart';

class FillupsPage extends StatefulWidget {
  final Map<String, dynamic> subjectData;
  final Map<String, dynamic> topicData;

  const FillupsPage({
    Key? key,
    required this.subjectData,
    required this.topicData,
  }) : super(key: key);

  @override
  _FillupsPageState createState() => _FillupsPageState();
}

class _FillupsPageState extends State<FillupsPage> {
  int _currentQuestionIndex = 0;
  final List<Map<String, dynamic>> _questions = [];
  final List<TextEditingController> _controllers = [];
  final List<bool?> _results = [];
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _initializeQuestions();
    
    // Initialize controllers and results
    for (int i = 0; i < _questions.length; i++) {
      _controllers.add(TextEditingController());
      _results.add(null);
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeQuestions() {
    // This would ideally come from a database or API
    // For now, we'll create sample questions based on the topic
    switch (widget.topicData['title']) {
      case 'Algebra':
        _questions.addAll([
          {
            'question': 'The process of finding the value of an unknown quantity is called ________.',
            'answer': 'solving',
            'hint': 'It starts with "s" and means finding a solution',
          },
          {
            'question': 'In the equation 2x + 5 = 13, the value of x is ________.',
            'answer': '4',
            'hint': 'Subtract 5 from both sides, then divide by 2',
          },
          {
            'question': 'The expression x² - 9 can be factored as ________ × ________.',
            'answer': '(x+3)(x-3)',
            'hint': 'It\'s a difference of squares',
          },
          {
            'question': 'If f(x) = 2x + 3, then f(5) = ________.',
            'answer': '13',
            'hint': 'Substitute x = 5 into the function',
          },
          {
            'question': 'The slope of a line represents its ________ or steepness.',
            'answer': 'gradient',
            'hint': 'Another word for incline or rate of change',
          },
        ]);
        break;
      case 'Grammar':
        _questions.addAll([
          {
            'question': 'A ________ is a word that names a person, place, thing, or idea.',
            'answer': 'noun',
            'hint': 'It\'s one of the basic parts of speech',
          },
          {
            'question': 'A ________ is a word that describes an action or state of being.',
            'answer': 'verb',
            'hint': 'It\'s the main part of the predicate of a sentence',
          },
          {
            'question': 'An ________ is a word that modifies a noun or pronoun.',
            'answer': 'adjective',
            'hint': 'It describes qualities like color, size, or shape',
          },
          {
            'question': 'A ________ is a group of words that contains a subject and a verb.',
            'answer': 'clause',
            'hint': 'It can be independent or dependent',
          },
          {
            'question': 'The ________ tense is used to describe actions happening now.',
            'answer': 'present',
            'hint': 'It\'s not past or future',
          },
        ]);
        break;
      default:
        _questions.addAll([
          {
            'question': 'The study of ${widget.topicData['title']} focuses on ________ principles.',
            'answer': 'fundamental',
            'hint': 'Basic or essential',
          },
          {
            'question': '${widget.topicData['title']} is an important field in ${widget.subjectData['title']} that helps us understand ________.',
            'answer': 'concepts',
            'hint': 'Ideas or notions',
          },
          {
            'question': 'The first principle of ${widget.topicData['title']} was discovered by ________.',
            'answer': 'scientists',
            'hint': 'People who conduct research',
          },
          {
            'question': 'In ${widget.topicData['title']}, we use ________ to measure progress.',
            'answer': 'methods',
            'hint': 'Procedures or techniques',
          },
          {
            'question': 'The application of ${widget.topicData['title']} can be seen in ________ everyday situations.',
            'answer': 'many',
            'hint': 'A large number of',
          },
        ]);
    }
  }

  void _checkAnswer() {
    setState(() {
      final currentAnswer = _controllers[_currentQuestionIndex].text.trim().toLowerCase();
      final correctAnswer = _questions[_currentQuestionIndex]['answer'].toString().toLowerCase();
      
      _results[_currentQuestionIndex] = currentAnswer == correctAnswer;
      _isSubmitted = true;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isSubmitted = false;
      });
    } else {
      _showResultDialog();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _isSubmitted = _results[_currentQuestionIndex] != null;
      });
    }
  }

  void _showHint() {
    final hint = _questions[_currentQuestionIndex]['hint'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hint: $hint'),
        backgroundColor: widget.subjectData['color'],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showResultDialog() {
    final correctCount = _results.where((result) => result == true).length;
    final totalQuestions = _questions.length;
    final percentage = (correctCount / totalQuestions * 100).toInt();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Results'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              percentage >= 70 ? Icons.check_circle : Icons.info,
              color: percentage >= 70 ? Colors.green : Colors.orange,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'You got $correctCount out of $totalQuestions correct!',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: percentage >= 70 ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              percentage >= 70 
                  ? 'Great job! You\'ve mastered this topic.' 
                  : 'Keep practicing to improve your score!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to topic page
            },
            child: const Text('Finish'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Reset the quiz
              setState(() {
                _currentQuestionIndex = 0;
                for (int i = 0; i < _controllers.length; i++) {
                  _controllers[i].clear();
                  _results[i] = null;
                }
                _isSubmitted = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.subjectData['color'],
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.topicData['title']} Fill-ups',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: widget.subjectData['color'],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            _buildProgressIndicator(),
            const SizedBox(height: 24),
            
            // Question card
            Expanded(
              child: _buildQuestionCard(currentQuestion),
            ),
            
            // Navigation buttons
            const SizedBox(height: 16),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _showHint,
              icon: const Icon(Icons.lightbulb_outline),
              label: const Text('Hint'),
              style: TextButton.styleFrom(
                foregroundColor: widget.subjectData['color'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _questions.length,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(widget.subjectData['color']),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fill in the blank:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              question['question'],
              style: const TextStyle(
                fontSize: 18,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _controllers[_currentQuestionIndex],
              decoration: InputDecoration(
                labelText: 'Your Answer',
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: widget.subjectData['color'], width: 2),
                ),
                suffixIcon: _isSubmitted
                    ? Icon(
                        _results[_currentQuestionIndex]! ? Icons.check_circle : Icons.cancel,
                        color: _results[_currentQuestionIndex]! ? Colors.green : Colors.red,
                      )
                    : null,
              ),
              enabled: !_isSubmitted,
              onSubmitted: (_) => _isSubmitted ? _nextQuestion() : _checkAnswer(),
            ),
            if (_isSubmitted) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _results[_currentQuestionIndex]! ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _results[_currentQuestionIndex]! ? Colors.green : Colors.red,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _results[_currentQuestionIndex]! ? Icons.check_circle : Icons.cancel,
                      color: _results[_currentQuestionIndex]! ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _results[_currentQuestionIndex]!
                            ? 'Correct! Well done.'
                            : 'Incorrect. The correct answer is: ${question['answer']}',
                        style: TextStyle(
                          color: _results[_currentQuestionIndex]! ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),
            if (!_isSubmitted)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.subjectData['color'],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Check Answer',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Previous'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.black87,
            disabledBackgroundColor: Colors.grey[100],
            disabledForegroundColor: Colors.grey,
          ),
        ),
        ElevatedButton.icon(
          onPressed: _isSubmitted ? _nextQuestion : null,
          icon: const Icon(Icons.arrow_forward),
          label: Text(_currentQuestionIndex < _questions.length - 1 ? 'Next' : 'Finish'),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.subjectData['color'],
            foregroundColor: Colors.white,
            disabledBackgroundColor: widget.subjectData['color'].withOpacity(0.3),
            disabledForegroundColor: Colors.white70,
          ),
        ),
      ],
    );
  }
}