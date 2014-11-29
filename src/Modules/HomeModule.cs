using Models;

namespace Modules
{
    using Nancy;
    
    public class HomeModule : NancyModule
    {
        public HomeModule()
        {
            Get["/foo2"] = _ => {
            	return new PartialProduct {Id=10202};
            };
        }
    }
}
