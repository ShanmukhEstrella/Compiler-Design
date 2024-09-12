%{
    #include<bits/stdc++.h>
    using namespace std;
	void yyerror(string);
	int yylex(void);
	char mytext[100];
	char var[100];
	int num = 0;
    extern int yylineno;
    int flag=0;
    map<string,vector<vector<string>>> productions;
    map<string,set<string>> first;
    map<string,set<string>> follow;
	extern char* yytext;
    string current_nonterminal;
    set<string> nonterminals;
    set<string> terminals;
    vector<string> s;
    string z;
    map<string,bool> isnullable;
    map<string,map<string,vector<string>>> dp;
    void findnullablehelp(string s)
    {
        bool b1 = false;
        for(auto it : productions[s])
        {
            bool b2 = true;
            for(auto x : it)
            {
                if(isnullable.find(x)==isnullable.end())
                {
                    findnullablehelp(x);
                }
                if(isnullable[x]==true)
                {
                    continue;
                }
                else
                {
                    b2 = false;
                    break;
                }
            }
            b1 = b1 || b2;
        }
        isnullable[s]=b1;
    }
    void findnullable()
    {
        for(auto it:nonterminals)
        {
            if(isnullable.find(it)==isnullable.end())
            {
                findnullablehelp(it);
            }
        }
    }
    void findfirsthelp(string s)
    {
        //cout<<"string s:" << s<<endl;
        for(auto it:productions[s])
        {
            for(auto x : it)
            {
                //cout<<"xin:"<<" "<<x<<endl;
                if(isnullable[x])
                {
                    if(first.find(x)==first.end())
                    {
                        findfirsthelp(x);
                        for(auto me:first[x])
                        {
                            first[s].insert(me);
                        }
                    }
                    else
                    {
                        //findfirsthelp(x);
                        for(auto me:first[x])
                        {
                            first[s].insert(me);
                        }
                    }
                }
                else
                {
                    if(first.find(x)==first.end())
                    {
                        findfirsthelp(x);
                        for(auto me:first[x])
                        {
                            first[s].insert(me);
                        }
                    }
                    else
                    {
                        //findfirsthelp(x);
                        for(auto me:first[x])
                        {
                            first[s].insert(me);
                            //cout<<s<<" "<<x<<" "<<me<<endl;
                        }
                    }
                    break;
                }
            }
        }
    }
    void findfirst()
    {
       //cout<<"B"<<" "<<*first["B"].begin()<<endl;
       for(auto it:nonterminals)
        {
            if(first.find(it)==first.end())
            {
                findfirsthelp(it);
            }
        }
        for(auto it:nonterminals)
        {
            if(isnullable[it])
            {
                first[it].insert("eps");
            }
        }
    }
    void findfollow()
    {
        for(auto it:productions)
        {
            for(auto x : productions[it.first])
            {
                for(int i=0;i<x.size();i++)
                {
                    for(int j=i+1;j<x.size();j++)
                    {
                        if(isnullable[x[j]])
                        {
                            for(auto ll:first[x[j]])
                            {
                                follow[x[i]].insert(ll);
                            }
                        }
                        else 
                        {
                            for(auto ll:first[x[j]])
                            {
                                follow[x[i]].insert(ll);
                            }
                            break;
                        }
                    }
                }
            }
        }
        for(auto it:productions)
        {
            for(auto x : productions[it.first])
            {
                for(int i=x.size()-1;i>=0;i--)
                {
                    if(isnullable[x[i]])
                    {
                        for(auto ll : follow[it.first])
                        {
                            follow[x[i]].insert(ll);
                        }
                    }
                    else
                    {
                         for(auto ll : follow[it.first])
                        {
                            follow[x[i]].insert(ll);
                        }
                        break;
                    }
                }
            }
        }

    }
%}

%union
{
	char strval[256];
}

%token<strval> TERMINAL
%token<strval> NONTERMINAL
%type<strval> ALT
%token ARROW SEMICOLON OR EPS QUERY FOLLOW FIRST PROD GRAMMAR

%%
START: GRAMMAR G
{

};
G: P G
|
P
{
    findnullable();
    findfirst();
    findfollow();
    for(auto it:nonterminals)
    {
        if(isnullable[it])
        {
            first[it].insert("eps");
        }
    }
    for(auto i : nonterminals)
    {
        for(auto j : terminals)
        {
            vector<string> v1(1,".");
            dp[i][j]=v1;
        }
    }
    for(auto it:nonterminals)
    {
        for(auto x : productions[it])
        {
            for(auto term : first[x[0]])
            {
                if(term!="eps")
                {
                    vector<string> v2;
                    v2.push_back(it);
                    v2.push_back(" ");
                    v2.push_back("->");
                    v2.push_back(" ");
                    for(auto hola:x)
                    {
                        v2.push_back(hola);
                    }
                    dp[it][term] = v2;
                }
            }
            if(first[x[0]].find("eps")!=first[x[0]].end())
            {
                for(auto term : follow[it])
                {
                    vector<string> v2;
                    v2.push_back(it);
                    v2.push_back(" ");
                    v2.push_back("->");
                    v2.push_back(" ");
                    for(auto hola:x)
                    {
                        v2.push_back(hola);
                    }
                    dp[it][term] = v2;
                }
                if(follow[it].find("$")!=follow[it].end())
                {
                    vector<string> v2;
                    v2.push_back(it);
                    v2.push_back(" ");
                    v2.push_back("->");
                    v2.push_back(" ");
                    for(auto hola:x)
                    {
                        v2.push_back(hola);
                    }
                    dp[it]["$"] = v2;
                }
            }
        }
    }
}
Q
{

};



P: NONTERMINAL{string s1 = yytext;current_nonterminal = s1; z = s1; isnullable[z]=false; if(!flag) {follow[s1].insert("$");} flag++;nonterminals.insert(s1);} ARROW ALTLIST SEMICOLON
{

}


ALTLIST: ALT{productions[current_nonterminal].push_back(s);s.clear();} OR ALTLIST
{

}
|
ALT
{
    productions[current_nonterminal].push_back(s);
    s.clear();
};


ALT: ALT NONTERMINAL
{
    string s1 = $2;
    s.push_back(s1);
}
|
ALT TERMINAL
{
    string s1 = $2;
    isnullable[s1]=false;
    s.push_back(s1);
    first[s1].insert(s1);
}
|TERMINAL
{
    string s1 = $1;
    s.push_back(s1);
    terminals.insert(s1);
    isnullable[s1]=false;
    first[s1].insert(s1);
}
|NONTERMINAL
{
   string s1 = $1;
   s.push_back(s1);
//    cout<<"NO"<<endl;
//    cout<<s1<<endl;
   nonterminals.insert(s1);
}
|EPS
{
    isnullable[z] = true;
    s.push_back("eps");
    first["eps"].insert("eps");
};

Q: QUERY RULE
{

};

RULE: RULE FIRST NONTERMINAL
{
    string s4 = $3;
    //cout<<s4<<endl;
    if(first[s4].size())
    {
        auto ptr = first[s4].end();
        ptr--;
        cout<<"{";
        for(auto it:first[s4])
        {
            if((*ptr) != it) cout<<it<<",";
            else cout<<it;
        }
        cout<<"}"<<endl;
    }
    else
    {
        cout<<"{}"<<endl;
    }
}
|
RULE FOLLOW NONTERMINAL 
{
    string s4 = $3;
    // cout<<s4<<" "<<"->";
    if(follow[s4].size())
    {
        auto ptr = follow[s4].end();
        ptr--;
        cout<<"{";
        for(auto it:follow[s4])
        {
            if((*ptr)!=it) cout<<it<<",";
            else cout<<it;
        }
        cout<<"}"<<endl;
    }
    else
    {
        cout<<"{}"<<endl;
    }
}
|
RULE PROD NONTERMINAL TERMINAL 
{
    string nt = $3;
    string t = $4;
    vector<string> ans = dp[nt][t];
    for(auto hola:ans)
    {
        cout<<hola;
    }
    cout<<endl;
}
|
{

};

%%
void yyerror(string s)
{
    string s2=yytext;
    cout<<s2<<endl;
    cout<<yylineno<<endl;
    cerr<<s<<endl;
    exit(0);
}


int main(void)
{
    yyparse();
    yylineno=1;
    return 0;
}

