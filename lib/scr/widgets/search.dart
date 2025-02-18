import 'package:flutter/material.dart';

class FixedSearchBar extends StatelessWidget {
  const FixedSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
       
        width: 400,
        child: Row(
          children: [
           
               Expanded(
                flex: 3,
                 child: Container(
                   width: 300, // Fixed width
                   height: 50, // Fixed height
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                     border: Border.all(
                       color: Colors.grey[300]!,
                       width: 1,
                     ),
                   ),
                   child: Row(
                     children: [
                       Expanded(
                         child: TextField(
                          style: TextStyle(fontSize: 12, color: Colors.white),
                           decoration: InputDecoration(
                             hintText: 'Email Address...',
                             
                             hintStyle: TextStyle(
                               color: Colors.grey[500],
                               fontSize: 12,
                             ),
                             contentPadding: const EdgeInsets.only(
                               left: 16,
                               bottom: 12,
                                top: 12,
                             ),
                             border: InputBorder.none,
                             enabledBorder: InputBorder.none,
                             focusedBorder: InputBorder.none,
                           ),
                         ),
                       ),
                      
                     ],
                   ),
                 ),
               ),
          SizedBox(width: 10,),
             Expanded(
              flex: 1,
               child: Container(
                width: 60,
                height: 50,
               
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius:  BorderRadius.circular(10
                      
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Get started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                             ),
             ),
        
          ],
        ),
      ),
    );
  }
}