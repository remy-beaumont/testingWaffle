namespace WebApplication1
{
    using Nancy;
    
    public class HomeModule : NancyModule
    {
        public HomeModule()
        {
            Get["/foo"] = _ => {
            	return new PartialProduct {Id=10202};
            };
        }
    }
}
