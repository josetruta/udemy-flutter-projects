import 'package:flutter/material.dart';

class QuestionsSummary extends StatelessWidget {
  const QuestionsSummary({
    super.key, 
    required this.summaryData
  });
  
  final List<Map<String, Object>> summaryData;
  
  @override
  Widget build(context) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          children: summaryData.map(
            (data) {
              return Row(children: [
                Container(
                  alignment: Alignment.center,
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data['user_answer'] == data['correct_answer'] 
                            ? const Color.fromARGB(255, 124, 219, 128)
                            : const Color.fromARGB(255, 219, 130, 124)
                  ),
                  child: Text(
                    ((data['question_index'] as int) + 1).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['question'] as String,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 208, 159, 247),
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(data['user_answer'] as String,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 208, 159, 247),
                          fontSize: 11
                        ),
                      ),
                      Text(data['correct_answer'] as String,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 172, 226, 173),
                          fontSize: 11
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                )
              ]);
            },
          ).toList(),
        ),
      ),
    );
  }
}