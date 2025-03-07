import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Principal "mo:base/Principal";


actor {
  type Tarefa = {
    id : Nat; // Identificador único da tarefa
    categoria : Text; // Categoria da tarefa
    descricao : Text; // Descrição detalhada da tarefa
    urgente : Bool; // Indica se a tarefa é urgente
    concluida : Bool; // Indica se a tarefa foi concluida
  };

  var idTarefa : Nat = 0;
  var tarefas : Buffer.Buffer<Tarefa> = Buffer.Buffer<Tarefa>(10);

  // Função para autenticação no login
  public shared(message) func get_principal_client() : async Text {
        return "Principal: " # Principal.toText(message.caller) # "!";
    };

  // Função para adicionar itens ao buffer 'tarefas'.
  public func addTarefa(desc: Text, cat: Text, urg: Bool, con: Bool) : async () {

      idTarefa += 1;
      let t : Tarefa = {  id = idTarefa;
                          categoria = cat;    
                          descricao = desc;                          
                          urgente = urg;                   
                          concluida = con;                   
                        };

      tarefas.add(t);
  };

  // Função para excluir itens ao buffer 'tarefas'.
  public func excluirTarefa(idExcluir : Nat) : async (){

    func localizaExcluir(_i: Nat, x: Tarefa) : Bool {
    return x.id != idExcluir;
  };
    tarefas.filterEntries(localizaExcluir);
  };
  
  public func alterarTarefa(idTar : Nat, desc : Text, cat : Text, urg : Bool, con : Bool) : async (){
    let t : Tarefa = { id = idTar;
                   categoria = cat;    
                   descricao = desc;                        
                   urgente = urg;                      
                   concluida = con;
                  };
    func localizaIndex (x: Tarefa, y: Tarefa) : Bool {
      return x.id == y.id;
    };

    let index : ?Nat = Buffer.indexOf(t, tarefas, localizaIndex);

    switch(index){
      case(null) {
          // não foi localizado um index
      };
      case(?i){
          tarefas.put(i,t);
      };
    }; 
  };

  // Função para retornar os itens do buffer 'tarefas'.
  public func getTarefas() : async [Tarefa] {
      return Buffer.toArray(tarefas);
  };

  // Função para retornar quantidade de tarefas no Buffer em andamento
  public func totalTarefasEmAndamento() : async Nat {
    var count: Nat = 0;
    for (value in tarefas.vals()){
      if (value.concluida == false){
        count +=1;
      };
    };
    return count;
  };
  
  // Função para retornar quantidade de tarefas no Buffer concluídas
  public func totalTarefasConcluidas() : async Nat {
    var count: Nat = 0;
    for (value in tarefas.vals()){
      if (value.concluida == true){
        count +=1;
      };
    };
    return count;
  }; 
};
