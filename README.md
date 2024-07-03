# todolist_with_riverpod

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

        Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(child: Text("Liste des tâches",style: Theme.of(context).textTheme.headlineLarge,)),
            //Chip options
            ChipsChoice<int>.multiple(
              choiceCheckmark: true,
              value: selectedItems,
              onChanged: (val) => setState(() {
                //on nettoie
                print(val);

                if(selectedItems.isNotEmpty){
                  if(val==1){
                    selectedItems=[0];
                  }else{
                    selectedItems=[1];
                  }
                }else{
                  selectedItems=val;
                }
              }),
              choiceItems: C2Choice.listFrom<int, String>(
                source: tasksFilteredOptions,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(roundedCardTask)),
                    color: secondary,
                    elevation: 2,
                    child: ListTile(
                      onTap: (){},
                      contentPadding: const EdgeInsets.symmetric(vertical: 9,horizontal: 9),
                      subtitle: Text("Lorem ipsum dolor sit amet, consectetur"
                          "adipiscing elit, sed do eiusmod tempor ",
                        overflow: TextOverflow.visible,
                        maxLines: 2
                        ,style: Theme.of(context).textTheme.bodyMedium,),
                      leading:Container(
                       width: 5,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(roundedCardTask)
                            ),
                            color: primary
                        ),
                      ),
                      title:Text("Réviser les cours",style: Theme.of(context).textTheme.headlineMedium,),
                      trailing: IconButton(
                        onPressed: (){},
                        icon: const Icon(Icons.check_circle,color: primary,size: 40,),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
