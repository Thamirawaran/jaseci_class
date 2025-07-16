import   from  mtllm.llm { Model }

glob llm = Model(model_name="gemini/gemini-2.5-flash");

def translate(eng_sentence: str, target_lang: str) -> str by llm(); 

with entry { 
    print(translate("Hello World", "Language spoken in Somalia")); 
    print(translate("Good morning", "The language of Cervantes")); 
    print(translate("Thank you", "What people speak in Tokyo")); 
}
